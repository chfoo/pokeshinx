package pokeshinx.view.object;

import h2d.Object;
import h2d.Particles;
import h3d.mat.Texture;
import haxe.ds.Vector;
import hxd.Res;

class TargetParticles extends Object {
    var particleSystems:Vector<Particles>;
    var particleSystemIndex = 0;

    public function new(?parent:Object) {
        super(parent);

        particleSystems = new Vector(5);
        var texture = Texture.fromPixels(
            Res.textures.texture.toBitmap().getPixels().sub(0, 640, 128, 128)
        );

        for (index in 0...particleSystems.length) {
            var particles = new Particles();
            var group = new ParticleGroup(particles);
            particles.addGroup(group);
            particleSystems[index] = particles;
            addChild(particles);

            group.enable = false;
            group.emitLoop = false;
            group.emitMode = Cone;
            group.name = "default";
            group.nparts = 3;
            group.rotSpeedRand = 4.0;
            group.rotSpeed = 0.1;
            group.animationRepeat = 0.0;
            group.fadeIn = 0;
            group.emitDelay = -0.5;
            group.size = 16 / texture.width;

            particles.onEnd = function() {
                group.enable = false;
            }

            group.texture = texture;
        }
    }

    public function show(x:Float, y:Float) {
        var particles = particleSystems[particleSystemIndex];

        particles.setScale(0.3 * ScreenUtil.getScreenScale());
        particles.x = x;
        particles.y = y;

        var group = particles.getGroup("default");

        group.enable = true;
        group.rebuild();

        particleSystemIndex += 1;

        if (particleSystemIndex >= particleSystems.length) {
            particleSystemIndex = 0;
        }
    }
}
