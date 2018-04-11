package ceramic;

import ceramic.Shortcuts.*;

import haxe.io.Path;

using StringTools;

class ShaderAsset extends Asset {

    public var shader:Shader = null;

    override public function new(name:String, ?options:AssetOptions) {

        super('shader', name, options);

    } //name

    override public function load() {

        status = LOADING;

        if (path == null) {
            warning('Cannot load shader asset if path is undefined.');
            status = BROKEN;
            emitComplete(false);
            return;
        }
        
        // Compute vertex and fragment shader paths
        if (path != null && (path.toLowerCase().endsWith('.frag') || path.toLowerCase().endsWith('.vert'))) {
            var paths = Assets.allByName.get(name);
            if (options.fragId == null) {
                for (path in paths) {
                    if (path.toLowerCase().endsWith('.frag')) {
                        options.fragId = path;
                        break;
                    }
                }
            }
            if (options.vertId == null) {
                for (path in paths) {
                    if (path.toLowerCase().endsWith('.vert')) {
                        options.vertId = path;
                        break;
                    }
                }
            }

            /*if (options.fragId != null || options.vertId != null) {
                path = Path.directory(path);
            }*/

            log('Load shader' + (options.vertId != null ? ' ' + options.vertId : '') + (options.fragId != null ? ' ' + options.fragId : ''));
        }
        else {
            log('Load shader $path');
        }

        if (options.vertId == null) {
            status = BROKEN;
            error('Missing vertId option to load shader at path: $path');
            emitComplete(false);
            return;
        }

        if (options.fragId == null) {
            status = BROKEN;
            error('Missing fragId option to load shader at path: $path');
            emitComplete(false);
            return;
        }

        app.backend.texts.load(options.vertId, function(vertSource) {
            app.backend.texts.load(options.fragId, function(fragSource) {

                if (vertSource == null) {
                    status = BROKEN;
                    error('Failed to load ' + options.vertId + ' for shader at path: $path');
                    emitComplete(false);
                    return;
                }

                if (fragSource == null) {
                    status = BROKEN;
                    error('Failed to load ' + options.fragId + ' for shader at path: $path');
                    emitComplete(false);
                    return;
                }

                var backendItem = app.backend.shaders.fromSource(vertSource, fragSource);
                if (backendItem == null) {
                    status = BROKEN;
                    error('Failed to create shader from data at path: $path');
                    emitComplete(false);
                    return;
                }

                this.shader = new Shader(backendItem);
                this.shader.asset = this;
                status = READY;
                emitComplete(true);

            });
        });

    } //load

    function destroy():Void {

        if (shader != null) {
            shader.destroy();
            shader = null;
        }

    } //destroy

/// Print

    function toString():String {

        var className = 'ShaderAsset';

        if (options.vertId != null || options.fragId != null) {
            var vertId = options.vertId != null ? options.vertId : 'default';
            var fragId = options.fragId != null ? options.fragId : 'default';
            return '$className($name $vertId $fragId)';
        }
        else if (path != null && path.trim() != '') {
            return '$className($name $path)';
        } else {
            return '$className($name)';
        }

    } //toString

} //ShaderAsset
