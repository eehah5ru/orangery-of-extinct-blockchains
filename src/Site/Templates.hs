{-# LANGUAGE OverloadedStrings #-}

module Site.Templates where

import Hakyll

rootTpl :: Identifier
rootTpl = "templates/root.slim"

indexPageTpl :: Identifier
indexPageTpl = "templates/index.slim"
