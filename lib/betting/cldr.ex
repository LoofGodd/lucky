# lib/betting/cldr.ex
defmodule Betting.Cldr do
  use Cldr,
    locales: ["en", "km"],
    default_locale: "en",
    providers: [Cldr.Number]
end
