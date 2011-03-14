# determine from text whether it is a murder notice

def is_murder?(text)
  unless text =~ /^RT/
    if text =~ /原発/u
      return true
    end
  end
  return false
end

