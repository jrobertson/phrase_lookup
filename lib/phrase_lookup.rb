#!/usr/bin/env ruby

# file: phrase_lookup.rb

# description: Returns a list of matching phrases from plain text


require 'yaml'
require 'rxfhelper'


class PhraseLookup

  def initialize(raw_s=nil)  

    @master = if raw_s then
      
      s = RXFHelper.read(raw_s).first
      
      if s.lstrip =~ /^---/ then # it's YAML
        
         Master.new(s)      
         
      elsif s =~ /: /   # it's the contents of a log file
        
         m = Master.new
         m.create s
         m
         
      else   # it's plain text
        
         m = Master.new
         m.create_from_txt s
         m
         
      end
      
    end
    

  end
  
  class Master    
    
    def initialize(yaml=nil)

      @h = yaml ? YAML.load(yaml) : {}
      
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
      
      a = s.downcase.gsub(/\?/,'').lines\
          .map {|x| x.strip[/(?<=: )[^|]+(?= )/i]}.compact
      a.uniq.inject({}) {|r,x| r.merge x => a.count(x)}
      
    end
  end

  def lookup(s, limit: 10)
    
    return [] if s.empty?
    
    h = @master.to_h
    a = h.keys
    
    a1 = a.grep /^#{s}/i
    a2 = a.grep /\b#{s}/i

    return (a1 + a2).uniq.sort_by {|word| -h[word]}.take limit
    
  end

  alias q lookup
  
  def master()
    @master
  end

  def save(filename='phrase_lookup.yaml')
    @master.save filename
  end
end