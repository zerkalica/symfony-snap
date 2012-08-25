<?php

class SeleniumTestsFixer
{
    protected $caseFixRegex = '#(<link.*?selenium\.base.*?href=").*?("[ \/]+>)#';
    protected $suiteFixRegex = '#<\?xml.*?>[\n\r]+#s';

    public function fix($source, $target, $url)
    {
        $it = new \RecursiveIteratorIterator(new \RecursiveDirectoryIterator($source));

        while($it->valid()) {
            if (!$it->isDot() && $it->isFile()) {
                $sourceFile = $it->key();
                $targetFile = $target . '/' . $it->getSubPathName();
                echo basename($sourceFile);
                $ok = false;
                if (preg_match('#.*\.case$#', $it->getSubPathName())) {
                    $ok = $this->replaceInFile($this->caseFixRegex, '${1}' . preg_quote($url) . '${2}', $sourceFile, $targetFile);
                }
                if (preg_match('#.*\.suite$#', $it->getSubPathName())) {
                    $ok = $this->replaceInFile($this->suiteFixRegex, '', $sourceFile, $targetFile);
                }

                echo ' [' . ($ok ? 'ok' : 'fail') . ']' . PHP_EOL;
            }
            $it->next();
        }
    }

    protected function replaceInFile($regex, $replaceTo, $srcFileName, $fileName)
    {
        if (!is_dir(dirname($fileName))) {
            mkdir(dirname($fileName), 0777, true);
        }
        $data = file_get_contents($srcFileName);

        $newData = preg_replace($regex, $replaceTo, $data);
        file_put_contents($fileName, $newData);

        return $data != $newData;
    }
}

$fixer = new SeleniumTestsFixer;

if (!isset($argv[3])) {
    echo "Usage: [selenium tests root directory] [output root directory] [selenium url]" . PHP_EOL;
    exit(1);
}

$fixer->fix($argv[1], $argv[2], $argv[3]);
