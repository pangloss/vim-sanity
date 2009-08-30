module VIM
  def self.comment(str)
    # grabs comments
    str.match(/\s*#[^{].*/) ? $~[0] : ''
  end

  def self.args(str, i)
    VIM::evaluate("s:mextargs(\"#{str}\", #{i})")
  end

  def self.indentation(str)
    str.match(/^\s*/) ? $~[0] : ''
  end

  class Buffer
    def each
      1.upto(length) do |i|
        yield self[i]
      end
    end

    def each_with_index
      1.upto(length) do |i|
        yield self[i], i
      end
    end

    def index_of(pattern)
      self.each_with_index {|line, i| return i if line.match(pattern) }
    end

    def end_of(i)
      VIM::evaluate("s:endof(#{i})").to_i
    end

    def error(msg)
      VIM::evaluate("s:error(\"#{msg}\")")
    end

    def open_fold_at(i)
#          VIM::evaluate("
#          if foldclosed(#{i}) > 0
#            exe '#{i}foldopen!'
#          endif"
    end

    def remove_between(start, finish)
      return if start + 1 == finish
      (start+1..finish-1).to_a.reverse.each {|i| self.delete(i) }
    end

    def multi_append(start, lines)
      (start..(start+lines.length-1)).each {|i| self.append(i, lines[i-start]) }
    end
  end

  class Rails
    def self.invert_range(start, finish)
      inverted_cmds = []
      i = start
      while(i <= finish)
        line = $curbuf[i]
        inverted_cmds << case line
        when /^\s*#[^{].*$/
          line
        when /\bcreate_table\b/
          i = $curbuf.end_of(i)
          "#{VIM::indentation(line)}drop_table#{VIM::args(line, 1)}#{VIM::comment(line)}"
        when /\bdrop_table\b/
          inverted_cmds << line.gsub(/drop_table\s*([^,){ ]*).*/, "create_table #{'\1'} do |t|")
          "#{VIM::indentation(line)}end#{VIM::comment(line)}"
        when /\badd_column\b/
          "#{VIM::indentation(line)}remove_column#{VIM::args(line, 2)}#{VIM::comment(line)}"
        when /\bremove_column\b/
          line.gsub(/\bremove_column\b/, 'add_column')
        when /\badd_index\b(.*)/
          "#{VIM::indentation(line)}remove_index#{$~[1]}"
        when /\bremove_index\b(.*)/
          line.gsub(/\bremove_index\b/, 'add_index').gsub(/:column\s*=>\s*/, '')
        when /\brename_(table|column)\b/
          line.gsub(/(\brename_(table|column)\b)\s+([^,]+)\s*,\s*([^,]+)\s*,\s*([^,]+)\s*/, '\1 \3, \5, \4')
        when /\.update_all$/, /\bchange_column(\b|_default\b)/
          # bleh, it's not worth it
          "##{line}"
        when /^\s*(if|unless|while|until|for)/
          i = $curbuf.end_of(i)
        end
        raise "Error parsing migration, aborting" if i < 1
        i += 1
      end
      inverted_cmds.compact
    end

    def self.rinvert!
      up_start = $curbuf.index_of(/def\s*self.up/)
      up_end = $curbuf.end_of(up_start)
      unless up_start > 0 && up_end > up_start
        return VIM::evaluate("s:error('Couldn't parse self.up method')")
      end
      inverted_cmds = []
      begin
        inverted_cmds = VIM::Rails::invert_range(up_start+1, up_end+1)
      rescue Exception => e
        return $curbuf.error(e.message)
      end
      down_start = $curbuf.index_of(/def\s*self.down/)
      down_end = $curbuf.end_of(down_start)
      unless down_start > 0 && down_end > down_start
        return $curbuf.error("Couldn't parse self.down method")
      end

      $curbuf.open_fold_at(down_start)
      $curbuf.remove_between(down_start, down_end)
      $curbuf.multi_append(down_start, inverted_cmds)
    end
  end
end
