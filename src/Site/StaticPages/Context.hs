{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}

module Site.StaticPages.Context where

import Hakyll

import qualified Site.Config as SiteCfg
import Site.Context

mkStaticPageCtx :: SiteCfg.Config -> Compiler (Context String)
mkStaticPageCtx cfg = mkSiteCtx (fst cfg) (snd cfg)
