{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_highkageshop (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/var/lib/postgresql/highkageshop/.stack-work/install/x86_64-linux/cde6ed5613aed701b9a3a3fe251262cb49d41aad88623f53f380efe00eb0dc26/8.0.2/bin"
libdir     = "/var/lib/postgresql/highkageshop/.stack-work/install/x86_64-linux/cde6ed5613aed701b9a3a3fe251262cb49d41aad88623f53f380efe00eb0dc26/8.0.2/lib/x86_64-linux-ghc-8.0.2/highkageshop-0.0.0-FKkemGJSbs1DRX1P7uBbR9"
dynlibdir  = "/var/lib/postgresql/highkageshop/.stack-work/install/x86_64-linux/cde6ed5613aed701b9a3a3fe251262cb49d41aad88623f53f380efe00eb0dc26/8.0.2/lib/x86_64-linux-ghc-8.0.2"
datadir    = "/var/lib/postgresql/highkageshop/.stack-work/install/x86_64-linux/cde6ed5613aed701b9a3a3fe251262cb49d41aad88623f53f380efe00eb0dc26/8.0.2/share/x86_64-linux-ghc-8.0.2/highkageshop-0.0.0"
libexecdir = "/var/lib/postgresql/highkageshop/.stack-work/install/x86_64-linux/cde6ed5613aed701b9a3a3fe251262cb49d41aad88623f53f380efe00eb0dc26/8.0.2/libexec"
sysconfdir = "/var/lib/postgresql/highkageshop/.stack-work/install/x86_64-linux/cde6ed5613aed701b9a3a3fe251262cb49d41aad88623f53f380efe00eb0dc26/8.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "highkageshop_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "highkageshop_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "highkageshop_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "highkageshop_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "highkageshop_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "highkageshop_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
