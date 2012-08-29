<?php

class FileList
{

    public function generate($source, $target, $body, $item)
    {
        $it = new \RecursiveIteratorIterator(new \RecursiveDirectoryIterator($source));
        $itemsData = '';
        $self      = basename($target);
        while($it->valid()) {
            if (!$it->isDot() && $it->isFile() && $it->getBaseName() != $self) {
                $sourceFile = $it->key();
                $path       = $it->getSubPathName();
                $subpath    = dirname($path);
                $basename    = pathinfo($it->getFileName(), PATHINFO_FILENAME);
                if ($subpath && $subpath != '.') {
                    $basename = $subpath . '/' . $basename;
                }
                $itemsData .= strtr($item, array(
                    '[path]' => $path,
                    '[basename]' => $basename,
                ));
            }
            $it->next();
        }

        file_put_contents($target, strtr($body, array('[items]' => $itemsData)));
    }
}

$fixer = new FileList;

if (!isset($argv[2])) {
    echo "Usage: [files directory] [output file]" . PHP_EOL;
    exit(1);
}

$body = '<!DOCTYPE html>
<html>
    <body>
        <ul>
            [items]
        </ul>
    </body>
<html>
';

$item = '
    <li>
        <a href="[path]">[basename]</a>
    </li>
';

$fixer->generate($argv[1], $argv[2], $body, $item);
