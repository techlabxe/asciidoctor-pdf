class Asciidoctor::Section
  def numbered_title opts = {}
    unless (@cached_numbered_title ||= nil)
      if (slevel = (@level == 0 && @special ? 1 : @level)) == 0
        @is_numbered = false
        @cached_numbered_title = @cached_formal_numbered_title = title
      elsif @numbered && !@caption && slevel <= (@document.attr 'sectnumlevels', 3).to_i
        @is_numbered = true
        sectnumber = %(#{sectnum})
        if slevel == 1 && @document.doctype == 'book'
          ellminate_dot = sectnumber[0, sectnumber.length-1]
          @cached_numbered_title = %(#{@document.attr 'chapter-label', 'Chapter'} #{ellminate_dot} #{@document.attr 'chapter-postlabel', ''} #{title})
        else
          @cached_numbered_title = %(#{sectnum} #{title})
        end
        @cached_formal_numbered_title = if slevel == 1 && @document.doctype == 'book'
          %(#{@cached_numbered_title}).lstrip
        else
          @cached_numbered_title
        end
      else
        @is_numbered = false
        @cached_numbered_title = @cached_formal_numbered_title = captioned_title
      end
    end
    opts[:formal] ? @cached_formal_numbered_title : @cached_numbered_title
  end unless method_defined? :numbered_title

  def part?
    @document.doctype == 'book' && @level == 0 && !@special
  end unless method_defined? :part?

  def chapter?
    @document.doctype == 'book' && (@level == 1 || (@special && @level == 0))
  end unless method_defined? :chapter?

  def part_or_chapter?
    @document.doctype == 'book' && @level < 2
  end unless method_defined? :part_or_chapter?
end
