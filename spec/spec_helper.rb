def fixture filename
    File.join(File.dirname(caller.first[/^.*:/]), 'fixtures', filename)
end

def tmp filename
    File.join(File.dirname(__FILE__), '..', 'tmp', filename)
end
