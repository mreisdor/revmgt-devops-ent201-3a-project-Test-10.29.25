# ATG Deployments - Introduction

This repository serves as a template which can be cloned for Salesforce DX project metadata backups. It contains all of the folders and files required to interact with Copado Essentials, ANT, and Salesforce CLI to create functional backups of Saleforce metadata from any org. Most often on a project, the Deployment Team will use Copado Essentials to create snapshots of an org to be used in the instance of a rollback. 

The basic process of creating a repository with this template and hooking it up to Copado Essentials will be covered below. In the rare cases where an advanced process needs to be used (e.g. you cannot use Copado Essentials on a project and the client requires the repository to be stored on their own instance of GitHub), a guideline for creating Salesforce backup repositories with Git is outlined in the "ATG Deployments - SFDX Processes" section of this README.

### Cloning This Repository for Copado Essentials

**1. Create a New Repository With This Template**

Click the "Create new..." button on the top right of the screen (contains a `+` within the button) and select the "New repository" option from the drop down. In the "Repository template" section, select `atginfo/atg-deployment-project-template`. Create a repository name which includes the Client's name so it is easily identifiable and ensure the repository is set to `Private`. Click the "Create repository" button once this is all complete. The repository is now successfully created and ready to be used with Salesforce metadata.

**2. Create an Organization in Copado Essentials**

Navigate to the Copado Essentials website [here](https://essentials.copado.com/app/#/Orgs) and click the "Create Organization" button. Change the Type to `GitHub`and provide the same name as on the repository created in Step 1 of this section. If you haven't created a GitHub organization before, you will be prompted to authorize your GitHub user. On the next screen, click the "select repository" button and find the repository which was created in Step 1. If you cannot find it, you may select the "enter manually" option and paste the repositories URL. Click the save button and the org should be established within Copado Essentials.

**3. Create a Backup from Copado Essentials**

In the deployment tab of Copado Essentials [here](https://essentials.copado.com/app/#/Flows), select the "New Deployment" button. Set the source org as the Salesforce org which needs to be backed up from and set the target org as the GitHub Organization which was created in Step 2 of this section. Leave the target branch option as `master` and hit the "Save" button. Navigate to the "Deploy Options" tab and click the "Change" button near the bottom of the screen. Set the Source Format to `Salesforce DX` and select the following options:
 - `Include user permissions`
 - `Ignore package version mismatch`
 - `Support component exclusion when deploying record types, profiles or language translations.`

Hit the "Save" button and select the components which need to be backed up from the "Add Components" tab. Once this is complete, hit the "Commit to Git Branch" button and the backup of selected components is successful. This process is outlined in-depth within the Deployment Project template created from the Deployment Team's OneNote.

**NOTICE:** If this template cannot be cloned, there is a video covering the process to create a Salesforce DX backup repository from scratch to be used with Copado Essentials stored in the Deployment Team's SharePoint. The only time a Release Engineer shouldn't be able to clone this template is if the backups are stored on a client's repository.  [Create a Salesforce DX Backup Repo from Scratch](https://cognizantonline.sharepoint.com/:v:/r/sites/ATG_Deployment-Team_MigratedCognizant/Shared%20Documents/General/Deployment%20Team%20Primary%20Folder/Training%20-%20Shared/VideoRepo/Github_BackupRepoCreation_from%20scratch.mp4?csf=1&web=1&e=McSaQX)


# ATG Deployments - SFDX Processes

### Create a Salesforce DX Project with Git

A Salesforce DX project has a specific structure and a configuration file that identifies the directory as a Salesforce DX project.

**1. Change to the directory where you want the DX project located.**
**2. Create the DX project.**

   ```
   sf project generate --name MyProject
   ```

If you don’t specify an output directory with the `--output-dir` flag, the project directory is created in the current     location. You can also use the `--default-package-dir` flag to specify the default package directory to target when syncing source to and from the org. If you don’t indicate a default package directory, this command creates a default package directory, `force-app`.

Use the `--template` flag to specify what your project initially looks like. Each template provides a complete directory structure that takes the guesswork out of where to put your source. If you choose `--template empty`, your project contains these sample configuration files to get you started.

* `.forceignore`
* `config/project-scratch-def.json`
* `sfdx-project.json`
* `package.json`

If you choose `--template standard`, your project also contains these files that are especially helpful when using Salesforce Extensions for VS Code. If you don’t specify the `--template` flag, the `project generate` command uses the standard template.

* `.gitignore`: Makes it easier to start using Git for version control.
* `.prettierrc` and `.prettierignore`: Make it easier to start using Prettier to format your Aura components.
* `.vscode/extensions.json`: Causes Visual Studio Code, when launched, to prompt you to install the recommended extensions for your project.
* `.vscode/launch.json`: Configures Replay Debugger, making it more discoverable and easier to use.
* `.vscode/settings.json`: By default, this file has one setting for excluding certain files and folders in searches and quick open. You can change this value or add other settings.

If you choose `--template analytics`, you get all the helpful basic and VS Code files. But the default package directory contains fewer directories, such as for storing Analytics template bundles. `/force-app/main/default/waveTemplates` and a few other metadata types, such as Apex classes and LWC components.

**EXAMPLES**
```
sf project generate --name mywork --template standard
```
```
sf project generate --name mywork --default-package-dir myapp-source
```

### Salesforce DX Project Configuration

The project configuration file `sfdx-project.json` indicates that the directory is a Salesforce DX project. The configuration file contains project information and facilitates the authorization of orgs and the creation of second-generation packages. It also tells Salesforce CLI where to put files when syncing between the project and org.

This is the default `sfdx-project.json` files for creating a project using Salesforce CLI or Salesforce Extensions for VS Code contained within this template.
```
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://test.salesforce.com",
  "sourceApiVersion": "59.0"
}
```

You can manually edit these parameters in the `sfdx-project.json` file

* **name (required for Salesforce Functions)**: Salesforce DX or Salesforce Functions project name.

* **namespace (optional)**: The global namespace that is used with a package. The namespace must be registered with an org that is associated with your Dev Hub org. This namespace is assigned to scratch orgs created with the `org create scratch` command. If you’re creating an unlocked package, you have the option to create a package with no namespace. Important: Register the namespace with Salesforce and then connect the org with the registered namespace to the Dev Hub org.

* **oauthLocalPort (optional)**: By default, the OAuth port is 1717. Change this port if 1717 is already in use and you plan to create a connected app in your Dev Hub org to support JWT-based authorization. Be sure you also follow the steps in [Create a Connected App in Your Org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_connected_app.htm) to change the callback URL.

* **packageAliases (optional)**: Aliases for package IDs, which can often be cryptic. See [Project Configuration File for a Second-Generation Managed Package](https://developer.salesforce.com/docs/atlas.en-us.pkg2_dev.meta/pkg2_dev/sfdx_dev2gp_config_file.htm) for details.

* **packageDirectories (required)**: Package directories indicate which directories to target when syncing source to and from the org. These directories can contain source files from your managed or unmanaged package. They can also contain unpackaged source files produced by, for example, an ant tool or change set. For information on all `packageDirectories` options, see [Project Configuration File for a Second-Generation Managed Package](https://developer.salesforce.com/docs/atlas.en-us.pkg2_dev.meta/pkg2_dev/sfdx_dev2gp_config_file.htm).

   Keep these things in mind when working with package directories.

  - The location of the package directory is relative to the project. Don’t specify an absolute path. The following two examples are equivalent. `"path": "helloWorld"` and `"path" : "./helloWorld"`
  - You can have only one default path (package directory). If you have only one path, we assume it’s the default, so you don’t have to explicitly set the `default` parameter. If you have multiple paths, you must indicate which one is the default.
  - Salesforce CLI uses the default package directory as the target directory when retrieving changes from the org to the local project. This default path is also used when creating second-generation packages.
  - If you don’t specify an output directory, the default package directory is also where files are stored during source conversions. Source conversions are both from metadata format to source format, and from source format to metadata format.

* **plugins (optional)**: To use the [custom plugins you’ve created](https://github.com/salesforcecli/cli/wiki/Quick-Introduction-to-Developing-sf-Plugins) with your Salesforce DX project, add a `plugins` section to the `sfdx-project.json` file. In this section, add configuration values and settings to change your plugins’ behavior.
```
"plugins": {
  "yourPluginName": {
    "timeOutValue": "2"
  },
  "yourOtherPluginName": {
    "yourCustomProperty": true
  }
}
```
Store configuration variables for only those values that you want to check in to source control for the project. These configuration values affect your whole development team.

* **replacements (optional)**: Automatically replace strings in your metadata source files with specific values right before you deploy the files to an org. See [Replace Strings in Code Before Deploying](https://developer.salesforce.com/docs/atlas.en-us.246.0.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_string_replace.htm) for details.

* **sfdcLoginUrl (optional)**: The login URL that the `org login` commands use. If not specified, the default is `https://login.salesforce.com`. Override the default value if you want users to authorize to a specific Salesforce instance. For example, if you want to authorize into a sandbox org, set this parameter to `https://test.salesforce.com`. If you don’t specify a default login URL here, or if you run `org login` outside the project, specify the instance URL when authorizing the org with the `--instance-url` flag.

* **sourceApiVersion (optional)**: The API version that the source is compatible with. The default is the same version as the Salesforce CLI. The `sourceApiVersion` value determines the fields retrieved for each metadata type during `project deploy`, `project retrieve`, or `project convert`. This field is important if you’re using a metadata type that has changed in a recent release. You’d want to specify the version of your metadata source. For example, let's say a new field was added to the CustomTab for API version 58.0. If you retrieve components for version 57.0 or earlier, you see errors when running the `project` commands because the components don't include that field. Don’t confuse this project configuration parameter with the [org-api-version](https://developer.salesforce.com/docs/atlas.en-us.246.0.sfdx_setup.meta/sfdx_setup/sfdx_dev_cli_config_values.htm) CLI configuration variable, which has a similar name. See [How API Version and Source API Version Work in Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.246.0.sfdx_setup.meta/sfdx_setup/sfdx_setup_apiversion.htm) for more information.


# ATG Deployments - Salesforce CLI Processes
Under Construction


# Git Processes

### Basic Workflows

* When retrieving a change set you have already deployed from RubixATG to FinDev, execute steps **1. Retrieve a Deployed Change Set** and **4. Merge a Package.xml to Master**.

* When retrieving metadata for deployment from RubixATG to FinDev, execute steps **2. Retrieve a Package.xml**, **3. Deploy a Package.xml**, and **4. Merge a Package.xml to Master**.


---
### 1. Retrieve a Deployed Change Set

1. Run `git checkout <yourbranchname>` to ensure you are on your personal branch
2. Run `git pull origin <yourbranchname>` to ensure you are up to date
3. Delete everything in the "retrieve_rubixatg" directory, if there are any files there
4. Copy the name of your change set
5. Find the "retrievePkg" command in the [build.xml](build.xml) file (line 29-32)
6. Within this command, paste the name of your change set into the "packageNames" parameter
7. For example, if your change set name is "My-Change-Set", the command will be:

    ```
        <target name="retrievePkg">
          <!-- Retrieve the contents into another directory -->
          <sf:retrieve username="${sf.sourceusername}" password="${sf.sourcepassword}" sessionId="${sf.sessionId}" serverurl="${sf.sandboxserverurl}" maxPoll="${sf.maxPoll}" retrieveTarget=retrieve_rubixatg packageNames="My-Change-Set" singlePackage="true"/>
        </target>
    ```

8. Save [build.xml](build.xml) and run `ant retrievePkg`
9. Now, the contents of your change set will be retrieved into the "retrieve_rubixatg" directory
10. Commit your changes:
    1. Run `git status` to check the status. You should see a list of files in red, including build.xml and all files in the "retrieve_rubixatg" directory
    2. Run `git add *` to stage all files for commit
    3. Run `git status` again to check the status. All files should now be in green, indicating they are staged for commit
    4. Run `git commit -m "My Message"` to commit the files. The message should be concise and descriptive, and start with an active verb
    5. For example, a good commit would be:

        ```
        git commit -m "Retrieve change set My-Change-Set into retrieve_rubixatg"
        ```

11. Once you have commited, run `git status` once more. You should see the message "Nothing to commit, working tree clean"
12. Run `git push origin <yourbranchname>` to update GitHub with your changes.


---
### 2. Retrieve a Package.xml

1. Run `git checkout <yourbranchname>` to ensure you are on your personal branch
2. Run `git pull origin <yourbranchname>` to ensure you are up to date
3. Delete all folders in the "retrieve_rubixatg" directory, if there are any files there
4. Remove all <types> tags from [retrieve_rubixatg/package.xml](retrieve_rubixatg/package.xml) *except* the profile tag.
5. Use the [FuseKit(TM)](https://staging.fusekit.io/app/deployment/generate-package-xml) Deploy > Generate Package.xml tool to create a package.xml with the metadata you wish to deploy
6. Merge this package.xml into [retrieve_rubixatg/package.xml](retrieve_rubixatg/package.xml) manually
    1. To do this,simply copy all <types> tags out of the package.xml you generated, and into [retrieve_rubixatg/package.xml](retrieve_rubixatg/package.xml)
    2. In the end, you should have something like:

        ```
        <?xml version="1.0" encoding="UTF-8"?>
        <Package xmlns="http://soap.sforce.com/2006/04/metadata">
            <types>
                <members>SomeObject.SomeField</members>
                <name>CustomField</name>
            </types>
            <types>
                <members>SomeProcessBuilder</members>
                <name>Flow</name>
            </types>
            <types>
                <members>SomeProfile</members>
                <members>SomeOtherProfile</members>
                <name>Profile</name>
            </types>
            <version>44.0</version>
        </Package>
        ```

7. Save [retrieve_rubixatg/package.xml](retrieve_rubixatg/package.xml) and run `ant retrieveUnpackaged`
8. Now, the contents of your package.xml will be retrieved into the "retrieve_rubixatg" directory
9. Commit your changes:
    1. Run `git status` to check the status. You should see a list of files in red, including all files in the "retrieve_rubixatg" directory
    2. Run `git add *` to stage all files for commit
    3. Run `git status` again to check the status. All files should now be in green, indicating they are staged for commit
    4. Run `git commit -m "My Message"` to commit the files. The message should be concise and descriptive, and start with an active verb
    5. For example, a good commit would be:

        ```
        git commit -m "Retrieve hotfix (sheet Hotfixes for Sprint 2, lines 13-17) into retrieve_rubixatg"
        ```

10. Once you have commited, run `git status` once more. You should see the message "Nothing to commit, working tree clean"
11. Run `git push origin <yourbranchname>` to update GitHub with your changes.


---
### 3. Deploy a Package.xml

1. This process assumes you have already completed **2. Retrieve a Package.xml**. If you have not completed this, please do so now
2. Run `git checkout <yourbranchname>` to ensure you are on your personal branch
3. Run `git pull origin <yourbranchname>` to ensure you are up to date
4. Duplicate the "retrieve_rubixatg" directory, assuming this is the directory you retrieved your metadata into
5. Name the new directory according to standards:
    1. If this is a sprint deployment: **deploy_sheetname_date**
    2. If this is a hotfix deployment: **hotfix_sheetname_rownumbers_date**
6. Find the "deployUnpackaged" command in the [build.xml](build.xml) file (line 35-37)
7. Within this command, paste the name of your new directory into the "deployRoot" parameter
8. For example, if your directory name is "hotfix_sheetname_rownumbers_date", the command will be:

    ```
        <target name="deployUnpackaged">
          <sf:deploy username="${sf.targetusername}" password="${sf.targetpassword}" sessionId="${sf.sessionId}" serverurl="${sf.sandboxserverurl}" maxPoll="${sf.maxPoll}" deployRoot="hotfix_sheetname_rownumbers_date" rollbackOnError="true" checkOnly="true"/>
        </target>
    ```
9. Verify that the "checkOnly" parameter in the command is set to true
    1. **If this parameter is set to false, the package will deploy rather than validating**
10. Save [build.xml](build.xml) and run `ant deployUnpackaged`
11. Review any errors and address them as normal
    1. This may require adding items to [retrieve_rubixatg/package.xml](retrieve_rubixatg/package.xml) and repeating process **2. Retrieve a Package.xml**
    2. It may also require making changes in SFDC or in the metadata files in your deployment directory
    3. Once your changes are made, copy the updated metadata package (if applicable) from "retrieve_rubixatg" into your deployment directory and rerun `ant deployUnpackaged`
    4. Repeat until the validation is successful
12. Upon successful validation, return to your build.xml and update the "checkOnly" parameter within the "deployUnpackaged" command to true
    1. **This will change the action from validation to deployment**
13. Run `ant deployUnpackaged`. At this time, the deployment into FinDev will be complete
14. Commit your changes:
    1. Run `git status` to check the status. You should see a list of files in red, including all files in your deployment directory and possibly the "retrieve_rubixatg" directory
    2. Run `git add *` to stage all files for commit
    3. Run `git status` again to check the status. All files should now be in green, indicating they are staged for commit
    4. Run `git commit -m "My Message"` to commit the files. The message should be concise and descriptive, and start with an active verb
    5. For example, a good commit would be:

        ```
        git commit -m "Deploy hotfix (sheet Hotfixes for Sprint 2, lines 13-17) to FinDev from <directoryname>"
        ```

15. Once you have commited, run `git status` once more. You should see the message "Nothing to commit, working tree clean"
17. *OPTIONAL:* Archive your deployment by moving your deployment directory into the "\_archive" folder
16. Run `git push origin <yourbranchname>` to update GitHub with your changes.


---
### 4. Merge a Package.xml to Master

1. Run `git checkout master` first. You need to update your master branch from GitHub before beginning
2. Run `git pull origin master` to update your master branch with the latest changes from GitHub
3. Run `git checkout <yourbranchname>` to ensure you are on your personal branch
4. Run `git pull origin <branchname` to ensure you are up to date
5. Run `git checkout master _allmetadata/package.xml` to update your main package ([\_allmetadata/package.xml](_allmetadata/package.xml)) with the latest changes from master
6. Navigate to the directory the package.xml you would like to merge is in, i.e.
    1. "retrieve_rubixatg" if following process **1. Retrieve a Change Set**
    2. Your deployment directory if following process **3. Deploy a Package.xml**
7. Identify which components need to be merged into [\_allmetadata/package.xml](_allmetadata/package.xml)
    1. If this was a small hotfix, you may know off the top of your head
    2. Otherwise, use BeyondCompare to determine what needs to be added
    3. __*If this deployment only updated existing metadata (no new lines to add to package.xml):*__
        1. Run `git checkout master`
        2. __**Skip to step 14**__
8. Merge your package.xml into [\_allmetadata/package.xml](_allmetadata/package.xml) manually
9. Commit your changes:
    1. Run `git status` to check the status. You should see a list of files in red, including only [\_allmetadata/package.xml](_allmetadata/package.xml)
    2. Run `git add *` to stage all files for commit
    3. Run `git status` again to check the status. All files should now be in green, indicating they are staged for commit
    4. Run `git commit -m "My Message"` to commit the files. The message should be concise and descriptive, and start with an active verb
    5. For example, a good commit would be:

        ```
        git commit -m "Merge hotfix (sheet Hotfixes for Sprint 2, lines 13-17) into _allmetadata/package.xml"
        ```

10. Once you have commited, run `git status` once more. You should see the message "Nothing to commit, working tree clean"
11. Run `git push origin <yourbranchname>` to update GitHub with your changes.
12. Run `git checkout master` to switch to the master branch. You will be performing the merge from here.
13. Run `git checkout --patch <yourbranchname> _allmetadata/package.xml`
    1. In Powershell, each hunk with changes (may be 1 or more lines) will pop up individually.
        1. To accept a change, type `y` and hit enter
        2. To decline a change, type `n` and hit enter
        3. In general, you should accept changes in green (additions) and decline changes in red (deletions). However, you should read each change and be sure you recognize it to confirm
14. Once you have successfully merged the package.xml, run `ant retrieveFinDev` to retrieve the updated package.xml from FinDev
    1. If you have removed any metadata from the package.xml, you may need to remove the file manually from the "\_allmetadata" directory. Review the directory to ensure the component is no longer there. Examples:
        1. A field will be automatically deleted, as the retrieve will completely overwrite the ".object" file it resides in
        2. An apex class will *not* be automatically deleted, as the retrieve will contain no file to overwrite it. The file will remain and will need to be manually deleted.
        3. If you're not sure whether you need to manually delete something, ask Nick or I. As a best practice, always double check to ensure deletions have occured.
15. Commit your changes:
    1. Run `git status` to check the status. You should see a list of files in red, including all files in the "\_allmetadata" directory
    2. Run `git add *` to stage all files for commit
    3. Run `git status` again to check the status. All files should now be in green, indicating they are staged for commit
    4. Run `git commit -m "My Message"` to commit the files. The message should be concise and descriptive, and start with an active verb
    5. For example, a good commit would be:

        ```
        git commit -m "Merge hotfix (sheet Hotfixes for Sprint 2, lines 13-17) from branch <yourbranchname>, retrieve from FinDev"
        ```
16. Once you have commited, run `git status` once more. You should see the message "Nothing to commit, working tree clean"
17. Run `git push origin master` to update GitHub with your changes.
18. Run `git checkout <yourbranchname>` to switch back to your own branch


---
### 5. Some Other Tips and Helpful Commands

* `git branch` will show you a list of all branches you have pulled down locally, highlighting the one you're currently on
* `git log -5` will show you the last 5 commits on your current branch ( Choose whatever number you want )
    * `git log -5 --oneline` is an easier to read version of this
* To automatically choose your upstream branch, you can run `git push -u origin <branchname>` _once_
    * From then on, this will make you much less error prone, as you can then simply run:
        * `git pull` instead of `git pull origin <yourbranchname>`
        * `git push` instead of `git push origin <yourbranchname>`
        * This will prevent you from, for example, accidentally pushing from your branch to master
* If you ever get into a really bad spot, `git reset --hard` will remove all changes you have made since your last commit
    * **Check with me before you do this, as this will _completely erase_ any changes you've made since your last commit**

# Salesforce App

This guide helps Salesforce developers who are new to Visual Studio Code go from zero to a deployed app using Salesforce Extensions for VS Code and Salesforce CLI.

## Part 1: Choosing a Development Model

There are two types of developer processes or models supported in Salesforce Extensions for VS Code and Salesforce CLI. These models are explained below. Each model offers pros and cons and is fully supported.

### Package Development Model

The package development model allows you to create self-contained applications or libraries that are deployed to your org as a single package. These packages are typically developed against source-tracked orgs called scratch orgs. This development model is geared toward a more modern type of software development process that uses org source tracking, source control, and continuous integration and deployment.

If you are starting a new project, we recommend that you consider the package development model. To start developing with this model in Visual Studio Code, see [Package Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/package-development-model). For details about the model, see the [Package Development Model](https://trailhead.salesforce.com/en/content/learn/modules/sfdx_dev_model) Trailhead module.

If you are developing against scratch orgs, use the command `SFDX: Create Project` (VS Code) or `sfdx force:project:create` (Salesforce CLI)  to create your project. If you used another command, you might want to start over with that command.

When working with source-tracked orgs, use the commands `SFDX: Push Source to Org` (VS Code) or `sfdx force:source:push` (Salesforce CLI) and `SFDX: Pull Source from Org` (VS Code) or `sfdx force:source:pull` (Salesforce CLI). Do not use the `Retrieve` and `Deploy` commands with scratch orgs.

### Org Development Model

The org development model allows you to connect directly to a non-source-tracked org (sandbox, Developer Edition (DE) org, Trailhead Playground, or even a production org) to retrieve and deploy code directly. This model is similar to the type of development you have done in the past using tools such as Force.com IDE or MavensMate.

To start developing with this model in Visual Studio Code, see [Org Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/org-development-model). For details about the model, see the [Org Development Model](https://trailhead.salesforce.com/content/learn/modules/org-development-model) Trailhead module.

If you are developing against non-source-tracked orgs, use the command `SFDX: Create Project with Manifest` (VS Code) or `sfdx force:project:create --manifest` (Salesforce CLI) to create your project. If you used another command, you might want to start over with this command to create a Salesforce DX project.

When working with non-source-tracked orgs, use the commands `SFDX: Deploy Source to Org` (VS Code) or `sfdx force:source:deploy` (Salesforce CLI) and `SFDX: Retrieve Source from Org` (VS Code) or `sfdx force:source:retrieve` (Salesforce CLI). The `Push` and `Pull` commands work only on orgs with source tracking (scratch orgs).

## The `sfdx-project.json` File

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

The most important parts of this file for getting started are the `sfdcLoginUrl` and `packageDirectories` properties.

The `sfdcLoginUrl` specifies the default login URL to use when authorizing an org.

The `packageDirectories` filepath tells VS Code and Salesforce CLI where the metadata files for your project are stored. You need at least one package directory set in your file. The default setting is shown below. If you set the value of the `packageDirectories` property called `path` to `force-app`, by default your metadata goes in the `force-app` directory. If you want to change that directory to something like `src`, simply change the `path` value and make sure the directory you’re pointing to exists.

```json
"packageDirectories" : [
    {
      "path": "force-app",
      "default": true
    }
]
```

## Part 2: Working with Source

For details about developing against scratch orgs, see the [Package Development Model](https://trailhead.salesforce.com/en/content/learn/modules/sfdx_dev_model) module on Trailhead or [Package Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/package-development-model).

For details about developing against orgs that don’t have source tracking, see the [Org Development Model](https://trailhead.salesforce.com/content/learn/modules/org-development-model) module on Trailhead or [Org Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/org-development-model).

## Part 3: Deploying to Production

Don’t deploy your code to production directly from Visual Studio Code. The deploy and retrieve commands do not support transactional operations, which means that a deployment can fail in a partial state. Also, the deploy and retrieve commands don’t run the tests needed for production deployments. The push and pull commands are disabled for orgs that don’t have source tracking, including production orgs.

Deploy your changes to production using [packaging](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_dev2gp.htm) or by [converting your source](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_source.htm#cli_reference_convert) into metadata format and using the [metadata deploy command](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_mdapi.htm#cli_reference_deploy).
