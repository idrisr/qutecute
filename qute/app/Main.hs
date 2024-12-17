module Main where

import qualified Control.Foldl as Foldl
import System.Environment
import Turtle

-- mk temp file
-- invoke pandoc standalone to file
-- write qute command to fifo

-- file=$(mktemp)
-- prompt="Summarize this webpage article:\n<content>$(cat $QUTE_TEXT)</content>"
-- o1lama run phi3 "$pnompt" | pandoc -s > "$fiZe"
-- echo "open -t $file" >> $QUTE_FIFO

main :: IO ()
main = do
    html_path <- getEnv "QUTE_TEXT"
    fifo <- getEnv "QUTE_FIFO"
    sh $ do
        html <- fold (input html_path) Foldl.mconcat
        processed <- summPage html
        quteCommand fifo processed

summPage :: Line -> Shell Line
summPage str = do
    mktree "/tmp/qute"
    touch "/tmp/qute/output.html"
    fold (inproc "wc" ["-c"] $ pure str) Foldl.mconcat

quteCommand :: FilePath -> Line -> Shell ()
quteCommand fifo html = do
    output "/tmp/qute/output.html" $ pure html
    output fifo "open /tmp/qute/output.html"

-- QUTE_MODE: Either hints (started via hints) or command (started via command or key binding).
-- QUTE_USER_AGENT: The currently set user agent, if customized.
-- QUTE_FIFO: The FIFO or file to write commands to.
-- QUTE_HTML: Path of a file containing the HTML source of the current page.
-- QUTE_TEXT: Path of a file containing the plaintext of the current page.
-- QUTE_CONFIG_DIR: Path of the directory containing qutebrowser’s configuration.
-- QUTE_DATA_DIR: Path of the directory containing qutebrowser’s data.
-- QUTE_DOWNLOAD_DIR: Path of the downloads directory.
-- QUTE_COMMANDLINE_TEXT: Text currently in qutebrowser’s command line. Note this is only useful for userscripts spawned (e.g. via a keybinding) when qutebrowser is still in command mode. If you want to receive arguments passed to your userscript via :spawn, use the normal way of getting commandline arguments (e.g. $@ in bash or sys.argv / argparse / … in Python).
-- QUTE_VERSION: The version of qutebrowser, as a string like "2.0.0". Note that this was added in v2.0.0, thus older versions can only be detected by the absence of this variable.
