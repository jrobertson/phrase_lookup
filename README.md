# Introducing the phrase_lookup gem

    require 'phrase_lookup'

    s = "
    how are you james
    how are you sally
    "

    pl = PhraseLookup.new s
    pl.q 'h'
    #=> ["how are you james", "how are you sally"]

    pl.q 'How are you Jam'
    #=> ["how are you james"]

    pl.q 'you Sally'
    #=> ["how are you sally"] 

## Resources

* phrase_lookup https://rubygems.org/gems/phrase_lookup

lookup query search phraselookup gem phrases

