{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}

module Site.StaticPages.Rules where

import Hakyll

import W7W.Rules.StaticPages

import qualified Site.Config as SiteCfg

import Site.Templates
import Site.StaticPages.Context

staticPagesRules :: SiteCfg.Config -> Rules ()
staticPagesRules cfg = do
  htmlPageRules cfg
  mdPageRules cfg
  slimPageRules cfg


htmlPageRules cfg = do
  staticHtmlPageRulesM rootTpl Nothing Nothing (mkStaticPageCtx cfg) "*.html"

mdPageRules cfg = do
  staticPandocPageRulesM rootTpl Nothing Nothing (mkStaticPageCtx cfg) "*.md"

slimPageRules cfg = do
  staticSlimPageRulesM rootTpl Nothing Nothing (mkStaticPageCtx cfg) "*.slim"
