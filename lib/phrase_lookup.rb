#!/usr/bin/env ruby

# file: phrase_lookup.rb

# description: Returns a list of matching phrases from plain text
# idea: return the list sorted by rank

require 'rxfhelper'


class PhraseLookup

  def initialize(raw_s=nil)

    @a = []

    if raw_s then

      s, _ = RXFHelper.read(raw_s) 
      parse s

    end
    
  end

  def lookup(s, limit: 10)

    a1 = @a.grep /^#{s}/i
    a2 = @a.grep /#{s}/i

    return (a1 + a2).uniq.take 10
  end

  alias q lookup

  def parse(s)

    @a = s.strip.lines.map(&:strip)

  end

end

