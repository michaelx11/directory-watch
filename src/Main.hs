import Control.Concurrent
import Data.Traversable      (traverse)
import System.IO             (stdin, stdout)
import System.Environment
import System.Exit
import System.Directory.Tree (AnchoredDirTree(..), DirTree(..), filterDir, readDirectoryWith)

main :: IO ()
main = getArgs >>= parse

parse ["-h"]   = usage   >> exit
parse ["-v"]   = version >> exit
parse []       = usage >> exit

-- For now, we do the naive thing and load each file into memory in full
-- Upon update, we simply compare the entire file again and then print the diff
parse path = do
    _:/tree <- readDirectoryWith return (head path)
    traverse putStrLn $ filterDir myPred tree
    threadDelay 10000000
    parse path
  where myPred (Dir ('.':_) _) = False
        myPred _ = True

usage   = putStrLn "Usage: directory-watch [path]"
version = putStrLn "directory-watch 0.1"
exit    = exitWith ExitSuccess
die     = exitWith (ExitFailure 1)
