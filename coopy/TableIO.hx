// -*- mode:java; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

#if !TOPLEVEL
package coopy;
#end

/**
 *
 * System services for the daff command-line utility.
 *
 */
@:expose
class TableIO {
    public function new() {
    }

    /**
     *
     * Read a file.
     * @param name the name of the file to read
     * @return the content of the file
     *
     */
    public function getContent(name: String) : String {
#if coopyhx_util
        return sys.io.File.getContent(name);
#else
        return "";
#end
    }

    /**
     *
     * Save a file.
     * @param name the name of the file to save
     * @param txt the content of the file
     * @return true on success
     *
     */
    public function saveContent(name: String, txt: String) : Bool {
#if coopyhx_util
        sys.io.File.saveContent(name,txt);
        return true;
#else
        return false;
#end
    }

    /**
     *
     * @return the command-line arguments
     *
     */
    public function args() : Array<String> {
#if coopyhx_util
        return Sys.args();
#else
        return [];
#end
    }

    /**
     *
     * @param txt text to write to standard output stream
     *
     */
    public function writeStdout(txt: String) : Void {
#if coopyhx_util
        Sys.stdout().writeString(txt);
#end
    }

    /**
     *
     * @param txt text to write to standard error stream
     *
     */
    public function writeStderr(txt: String) : Void {
#if coopyhx_util
        Sys.stderr().writeString(txt);
#end
    }

    /**
     *
     * Execute a command.
     * @param cmd the command to execute
     * @param args the arguments to pass
     * @return the return value of the command
     *
     */
    public function command(cmd:String, args:Array<String>) : Int {
#if coopyhx_util
        try {
            return Sys.command(cmd,args);
        } catch (e: Dynamic) {
            return 1;
        }
#else
        return 1;
#end
    }

    /**
     *
     * @return true if the platform has no built-in way to call a command
     * synchronously i.e. IT IS NODE
     *
     */
    public function async() : Bool {
        return false;
    }

    /**
     *
     * Check if a file exists.
     * @param path the name of the (putative) file
     * @return true if the file exists
     *
     */
    public function exists(path:String) : Bool {
#if coopyhx_util
        return sys.FileSystem.exists(path);
#else
        return false;
#end
    }

    /**
     *
     * Try to open an sqlite database.
     * @param path to the database
     * @return opened database, or null on failure
     *
     */
    public function openSqliteDatabase(path: String) : SqlDatabase {
        return null;
    }
}

