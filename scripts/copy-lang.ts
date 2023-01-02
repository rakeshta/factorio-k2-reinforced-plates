//
//  copy-lang.ts
//  factorio-k2-reinforced-plates
//
//  Created by Rakesh Ayyaswami on 03 Jan 2023.
//

import fs from 'fs';
import ConfigParser from 'configparser';

const K2_LANG_FILE = 'Krastorio2.cfg';
const LANG_FILE = 'lang.cfg';
const LANG_KEYS = [];

async function main(): Promise<void> {
  // check if the source folder was passed as an argument
  if (process.argv.length < 3) {
    return printUsage();
  }

  // check that the given source folder exists
  const srcFolder = process.argv[2];
  if (!fs.existsSync(srcFolder)) {
    console.error(`Source folder ${srcFolder} does not exist`);
    return printUsage();
  }

  // enumerate language folders & copy strings
  const localeFolder = `${srcFolder}/locale`;
  for (const locale of fs.readdirSync(localeFolder, { withFileTypes: true })) {
    if (locale.isDirectory()) {
      await copyLocale(localeFolder, locale.name);
    }
  }
}
main();

async function copyLocale(localeFolder: string, locale: string): Promise<void> {
  console.log(`Copying ${locale}...`);

  // read the source file
  const config = new ConfigParser();
  config.read(`${localeFolder}/${locale}/${K2_LANG_FILE}`);

  // destination config
  const destConfig = new ConfigParser();
  let isEmpty = true;

  // find keys we want to copy & write to dest
  for (const section of config.sections()) {
    let isSectionAdded = false;
    for (const key of LANG_KEYS) {
      const value = config.get(section, key);
      if (value) {
        console.log(`  ${section}/${key} = ${value}`);

        // add section if required
        if (!isSectionAdded) {
          destConfig.addSection(section);
          isSectionAdded = true;
        }

        // write value
        destConfig.set(section, key, value);
        isEmpty = false;
      }
    }
  }

  // write dest config if not empty
  if (!isEmpty) {
    // create dest folder
    // const destFolder = `locale/${locale}`;
    // fs.mkdirSync(destFolder, { recursive: true });

    // write config
    const destFile = `locale/${locale}/${LANG_FILE}`;
    destConfig.write(destFile, true);
  }
}

function printUsage(): void {
  console.log('Usage: ts-node copy-lang <krastorio2-folder>');
}
