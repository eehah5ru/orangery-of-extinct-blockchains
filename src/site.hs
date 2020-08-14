{-# LANGUAGE OverloadedStrings #-}


-- import           Data.ByteString.Lazy as BSL
import           Data.Default (def)
import Data.Maybe (fromMaybe)


-- import           Data.Monoid (mappend, (<>))
import           Hakyll
-- import           Hakyll.Core.Configuration (Configuration, previewPort)
-- import           Hakyll.Core.Metadata
import Hakyll.Core.Compiler (getUnderlying)
import Hakyll.Web.Template.Internal (readTemplate)


import W7W.Types
import W7W.MultiLang
import W7W.Compilers.Slim
import qualified W7W.Cache as Cache
import qualified W7W.Config as W7WConfig

import W7W.Rules.Templates
import W7W.Rules.Assets
import W7W.Pictures.Rules
-- import W7W.Rules.StaticPages

import W7W.Labels.Parser

import Site.Config
import Site.StaticPages.Rules


-- import Site.Context
-- import Site.Template

-- import Site.StaticPages.Rules
-- import Site.Archive.Rules

-- import Site.CollectiveGlossary
-- import Site.CollectiveGlossary.Rules

--------------------------------------------------------------------------------

config :: Configuration
config = W7WConfig.config { previewPort = 8111}

picturesConfig =
  copyAllPicturesRulesConfig {othersStrategy = PicResizeStrategy (1280, 1280)}

main :: IO ()
main = do
  caches <- Cache.newCaches
  labels <- parseLabelsYaml
  cfg <- return $ mkSiteConfig caches labels

  hakyllWith config $
    do

       templatesRules

       imagesRules -- static assets
       picturesRules picturesConfig "pictures"
       fontsRules
       dataRules

       cssAndSassRules ("css/_*.scss" .||. "css/**/_*.scss") [ "css/app.scss"]

       jsRules


       -- slim partials for deps
       -- match ("ru/**/_*.slim" .||. "en/**/_*.slim") $ compile getResourceBody


       staticPagesRules cfg


--------------------------------------------------------------------------------
