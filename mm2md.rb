#!/usr/bin/env ruby
# (Very) Hackish script to convert Freemind XML input into text or html. 
# TODO: Actually parse XML

markdown = (ARGV.grep(/text/).empty?)
if markdown
  require 'rubygems' #Ruby1.8
  require 'maruku'
  indent    = "\t"
  indentend = "*\t"
else
  indent    = "\t"
  indentend = ""
end

#inputname = ARGV[1] || 'info3402.mm'

`ls */*.mm`.each do |inputname| #Hey, I did say it was hackish
  input = `cat #{inputname}` #File.read(inputname).split("\n") #Can't be bothered using the standard library; don't care about platform compatibility
  outname = (inputname).split('.').first + ".#{(markdown ? "md" : "txt")}" #cf last comment
  outfile = File.new(outname, 'w')

  depth = 0
  output = ""

  input.each_with_index do |line, i|
    #next if i <= 1 #headers
    if line =~ /<\/node>/
      depth -= 1 
      output += "\n"
    elsif line =~ /TEXT/
      output += indent * depth + indentend + line.match(/TEXT="[^"]*/).to_s.split('"')[1].gsub('*','') + "\n"
      if line =~ /">/
        depth += 1 
        output += "\n" if markdown
      end
    end
  end

  if markdown
    outfile.puts output #Maruku.new(output).to_html #Use server to dynamically generate
  else
    outfile.puts output
  end
end
