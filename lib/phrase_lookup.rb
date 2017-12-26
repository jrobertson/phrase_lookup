#!/usr/bin/env ruby

# file: phrase_lookup.rb

# description: Returns a list of matching phrases from plain text


require 'yaml'
require 'rxfhelper'


class PhraseLookup

  def initialize(obj=nil)  

    @master = if obj then
      
      if obj.is_a? String then
        
        s = RXFHelper.read(obj).first
        
        if s.lstrip =~ /^---/ then # it's YAML
          
          Master.new( YAML.load(s))
          
        elsif s =~ /: /   # it's the contents of a log file
          
          m = Master.new
          m.create s
          m
          
        else   # it's plain text
          
          m = Master.new
          m.create_from_txt s
          m
          
        end
      else
        Master.new obj
      end
      
    end
    

  end
  
  class Master    
    
    def initialize(h={})

      @h = h
      
    end
    
    def create(s)
      
      @h = parse_log(s)
      
    end
    
    def create_from_txt(s)
      
      @h = parse(s)
      
    end    
    
    def update(s)

      parse_log(s).each {|k,v| @h.has_key?(k) ? @h[k] += v : @h[k] = v }

    end
    
    def save(filename='master.yaml')
      File.write filename, @h.sort.to_h.to_yaml
    end
    
    def to_h()
      @h.clone
    end
    
    private
    
    def parse(raw_s)
      
      s, _ = RXFHelper.read(raw_s)       
      
      a = s.downcase.gsub(/\?/,'').lines.map(&:strip).compact
      a.uniq.inject({}) {|r,x| r.merge x => a.count(x)}
      
    end    
    
    def parse_log(raw_s)
      
      s, _ = RXFHelper.read(raw_s)       
      
      a = s.downcase.gsub(/\?/,'').lines.map do |x| 
        phrase = x.strip[/(?<=: )[^|]+(?= )/i]
        phrase.length < 50 ? phrase : nil if phrase
      end.compact
      
      a.uniq.inject({}) {|r,x| r.merge x => a.count(x)}
      
    end
  end

  def lookup(s, limit: 10, search_tags: false)
    
    return [] if s.empty?
    
    h = @master.to_h
    a = h.keys
    
    a3 = if search_tags then
      a.grep /\].*(?:\b#{s}\b|\b#{s}).*\|.*(?:\b#{s}\b|\b#{s})/i
    else
      a1, a2 = [/^#{s}/i, /\b#{s}/i].map do |regex|
        a.select {|x| x.gsub(/\[[^\]]*\]/,'').gsub(/\([^\)]*\)/,'') =~ regex}
      end
      (a1 + a2)
    end

    return a3.sort_by {|word| -h[word]}.map {|x| x.sub(/ +\|.*$/,'')}\
        .uniq.take(limit)        
    
  end

  alias q lookup
  
  def master()
    @master
  end

  def save(filename='phrase_lookup.yaml')
    @master.save filename
  end
end