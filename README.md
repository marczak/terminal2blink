# Hi!
terminal2blink is a simple utility to convert macOS terminal profiles to [Blink Shell](https://blink.sh). When I say "simple", it's both in terms of "easy-to-use", and its quality.

# Why?
If you have a fairly intricate terminal theme for your macOS terminal, and would like the same one in Blink, this is for you. I have one terminal theme I like, and was way too lazy to convert it by hand.

# Use
Export your theme from macOS terminal, which will create a `.terminal` file. Run terminal2blink:

`terminal2blink foo.terminal`

This will output `[Terminal Name].js`. Copy the contents of `[Terminal Name].js`:

`cat Red\ Sands.js | pbcopy`

...and create a GitHub gist at https://gist.github.com. Name it, and paste in the contents. Click the "Raw" button to get the raw URL.

Launch Blink Shell, run `config`, and tap on "Appearence", then "New Theme". Copy the raw URL into the URL Address field.

# What's Missing?
Not everything in macOS terminal translates directly to Blink Shell. terminal2blink will correctly translate colors, cursor blink, and more. However, I know (at least) the following is missing:

- If you're using a non-system-supplied font, terminal2blink will not translate it. You'll have to see [these instructions](https://css-tricks.com/snippets/css/using-font-face/) and edit the resulting config file.

- Blink shell only has one cursor type: block. So that's what you get.

Didn't know Blink Shell supported themes, or want to browse existing themes? Check out the [official docs](https://github.com/blinksh/blink/blob/raw/Resources/FontsAndThemes.md).

# By The Way
I could have chosen other languages to write this in, but I wanted to finally write some Swift. This is the first thing I've written in Swift, and probably looks like it. I happily take constructive criticism, and pull requests are welcome. (Could something be more idiomatic Swift? Let me know! Want to contribute code to fix an issue or cover a TODO? Have at it.)

# TODO
- Better error checking.
- Support .terminal files hosted at a URL rather than just on-disk.
- Support font conversion.

