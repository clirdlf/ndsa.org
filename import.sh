ruby -rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::RSS.run({
      "source" => "https://www.diglib.org/topics/ndsa/feed/"
    })'
