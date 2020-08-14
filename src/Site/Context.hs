{-# LANGUAGE OverloadedStrings #-}
module Site.Context where

import Control.Monad.Trans.Class
import Control.Monad.Reader

import Control.Applicative (Alternative (..))

import System.Random

import Hakyll
import Hakyll.Core.Compiler.Internal (compilerUnsafeIO)

import Data.Monoid ((<>), mempty)

import W7W.MonadCompiler
import W7W.MultiLang
import W7W.Utils
import W7W.Context

import W7W.Labels.Types
import W7W.Labels.Context

import qualified W7W.Cache as Cache


--
-- snapshot "content" of the item
--
fieldContent :: Context String
fieldContent = field "content" content'
  where
    content' i = loadSnapshotBody (itemIdentifier i) "content"


fieldRandomFunction =
  functionField "random" f
  where
    usage = "usage: random(min, max)"
    f [] _ =  error $ "random: empty args. " ++ usage
    f ([_]) _ = error $ "too few args. " ++ usage
    f [minS, maxS] _ = return . show =<< compilerUnsafeIO getRandomInt
      where
        getRandomInt = do
          g <- newStdGen
          (i, g') <- return $ randomR (min, max) g
          return i
        min :: Int
        min = read minS

        max :: Int
        max = read maxS

    f _ _ = error $ "too many args. " ++ usage

--
-- minimal
--
minimalSiteCtx :: Context String
minimalSiteCtx =
  fieldRuUrl
    <> fieldEnUrl
    <> fieldLang
    <> fieldOtherLang
    <> fieldOtherLangUrl
    <> fieldCanonicalName
    <> fieldRandomFunction
    <> defaultContext

--
-- site default
--
mkSiteCtx :: Cache.Caches -> Labels -> Compiler (Context String)
mkSiteCtx caches labels = do
  r <- mkFieldRevision caches
  ls <- runReaderT mkLabelsField labels
  return $ minimalSiteCtx
           <> r
           <> ls

siteCtx :: (MonadReader r m, MonadCompiler m, Cache.HasCache r, HasLabels r) => m (Context String)
siteCtx = do
  c <- asks Cache.getCache
  ls <- asks getLabels
  liftCompiler $ mkSiteCtx c ls
