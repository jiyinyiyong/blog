
再次尝试 Three.js 绘制图形
------

起因是之前版本的 [Snowflake][snow] 被导师说答辩会遇到些困难, 要加功能
就是说, 3D, 我现在可以企及的版本是 Three.js , 也需要努力

[snow]: http://weibo.com/1651843872/zwGDOyd2c

此前尝试过用 Three.js 写了个 3D 旋转的平面, 但更多不得要领
晚上我想是否可以刻意区分开去学习每个部分的对象怎么调用, 来完成学习
用 Bower 安装了 Three.js , 不过耽搁了没开始, 明晚再看看吧

https://github.com/mrdoob/three.js/wiki/Getting-Started
http://threejs.org/docs/58/#Manual/Introduction/Creating_a_scene
http://stackoverflow.com/questions/14716336/how-to-drag-a-scene-in-three-js

基本的 Demo, 画一个 Cube
------

调试的页面 `index.jade` 内容:

```jade
doctype 5
html
  head
    meta(charset="utf-8")
    title 3js
    script(src="../components/threejs/build/three.js")
    script(defer, src="build.js")
    link(rel="stylesheet", href="page.css")
  body#main
```

这是两个教程上都写的开篇的代码:
https://github.com/mrdoob/three.js/wiki/Getting-Started
http://threejs.org/docs/58/#Manual/Introduction/Creating_a_scene

```coffee
scene = new THREE.Scene
ratio = window.innerWidth / window.innerHeight
camera = new THREE.PerspectiveCamera 75, ratio, 0.1, 1000

renderer = new THREE.WebGLRenderer
renderer.setSize window.innerWidth, window.innerHeight
document.body.appendChild renderer.domElement

geometry = new THREE.CubeGeometry 1, 1, 1
material = new THREE.MeshBasicMaterial color: 0x00ff00
cube = new THREE.Mesh geometry, material
scene.add cube

camera.position.z = 5

do render = ->
  requestAnimationFrame render
  renderer.render scene, camera
  cube.rotation.x += 0.01
  cube.rotation.y += 0.01
```

仅仅是这样的时候, Three.js 的使用是非常清晰的

画直线
------

```coffee

scene = new THREE.Scene
ratio = window.innerWidth / window.innerHeight
camera = new THREE.PerspectiveCamera 45, ratio, 0.1, 500
camera.position.set 0, 0, 100
camera.lookAt (new THREE.Vector3 0, 0, 0)

renderer = new THREE.WebGLRenderer
renderer.setSize window.innerWidth, window.innerHeight
document.body.appendChild renderer.domElement

geometry = new THREE.CubeGeometry
geometry.vertices.push (new THREE.Vector3 -10, 0, 0)
geometry.vertices.push (new THREE.Vector3 0, 10, 0)
geometry.vertices.push (new THREE.Vector3 10, 0, 0)
material = new THREE.LineBasicMaterial color: 0x0000ff
line = new THREE.Line geometry, material
scene.add line

renderer.render scene, camera
```

直线完成, 不过是静态的. 动画是 `requestAnimationFrame` 写的
这里还是能看出来清晰的界面渲染次序, 以及常用的 API
Three.js 支持的几个 Feature, 我把上边出现的从中间断开:
https://github.com/mrdoob/three.js/wiki/Features

* Renderers: WebGL, \<canvas\>, \<svg\>, CSS3D, DOM, Software; effects: anaglyph, crosseyed, stereo and more
* Scenes: add and remove objects at run-time; fog
* Cameras: perspective and orthographic; controllers: trackball, FPS, path and more
* Animation: morph and keyframe
* Materials: Lambert, Phong and more - all with textures, smooth-shading and more
* Geometry: plane, cube, sphere, torus, 3D text and more; modifiers: lathe, extrude and tube
* Objects: meshes, particles, sprites, lines, ribbons, bones and more - all with level of detail

* Lights: ambient, direction, point, spot and hemisphere lights; shadows: cast and receive
* Shaders: access to full WebGL capabilities; lens flare, depth pass and extensive post-processing library
* Loaders: binary, image, JSON and scene
* Utilities: full set of time and 3D math functions including frustum, quaternion, matrix, UVs and more
* Export/Import: utilities to create Three.js-compatible JSON files from within: Blender, CTM, FBX, 3D Max, and OBJ
* Support: API documentation is under construction, public forum and wiki in full operation
* Examples: More than 150 files of coding examples plus fonts, models, textures, sounds and other support files

Camera
------

`Camera` 用到的都是 `PerspectiveCamera`, 锥形的视野,
从 `Camera` 继承, 默认有如下的四个属性
http://threejs.org/docs/58/#Reference/Cameras/PerspectiveCamera
https://github.com/mrdoob/three.js/blob/master/src/cameras/PerspectiveCamera.js#L7
```js
THREE.Camera.call( this );

this.fov = fov !== undefined ? fov : 50;
this.aspect = aspect !== undefined ? aspect : 1;
this.near = near !== undefined ? near : 0.1;
this.far = far !== undefined ? far : 2000;
```

而 `Camera` 是从 `Object3D` 继承的, 自己定义了 `lookAt` 方法
http://threejs.org/docs/58/#Reference/Cameras/Camera
https://github.com/mrdoob/three.js/blob/master/src/cameras/Camera.js#L7

`Object3D` 定义的属性和方法就非常多了
http://threejs.org/docs/58/#Reference/Core/Object3D

感觉能用到的属性有:

* .children
Array with object's children.

* .position
Object's local position.

* .rotation
Object's local rotation (Euler angles), in radians.

* .scale
Object's local scale.

* .visible
Object gets rendered if true.

目测能用到的方法有:

* .translateX( distance )
distance - Distance.
Translates object along x axis by distance.

* .translateY( distance )
distance - Distance.
Translates object along y axis by distance.

* .translateZ( distance )
distance - Distance.
Translates object along z axis by distance.

* .lookAt( vector )
vector - A world vector to look at.
Rotates object to face point in space.

* .add( object )
object - An object.
Adds object as child of this object.

* .remove( object )
object - An object.
Removes object as child of this object.

这样看来文档挺清晰的, 其中很多比如 `.position .rotation` 是 `Vector3`
http://threejs.org/docs/58/#Reference/Math/Vector3
基本的属性就是 `x y z` 三者, 经常就是坐标了

```js
THREE.Vector3 = function ( x, y, z ) {

	this.x = x || 0;
	this.y = y || 0;
	this.z = z || 0;

};
```

然后是大量操作 `Vector3` 的方法, 有数学基础大概能懂意思
另外 `Vector2` `Vector4` 类似, 以及 `Quaternion` 四元数

在类似的在 `Math` 里定义了一些常用的方法:
http://threejs.org/docs/58/#Reference/Math/Math
`Color` 是封装过的数据类型, 提供了多种方法进行操作:
http://threejs.org/docs/58/#Reference/Math/Color

Object 的 Line 和 Mesh
------

`Line` 和 `Mesh` 继承在 `Object` 下, 似乎没啥属性和方法:

https://github.com/mrdoob/three.js/blob/master/src/objects/Line.js#L5
```js
THREE.Line = function ( geometry, material, type ) {

	THREE.Object3D.call( this );

	this.geometry = geometry;
	this.material = ( material !== undefined ) ? material : new THREE.LineBasicMaterial( { color: Math.random() * 0xffffff } );
	this.type = ( type !== undefined ) ? type : THREE.LineStrip;

	if ( this.geometry ) {

		if ( ! this.geometry.boundingSphere ) {

			this.geometry.computeBoundingSphere();

		}

	}

};
```

https://github.com/mrdoob/three.js/blob/master/src/objects/Mesh.js#L8
```js
THREE.Line = function ( geometry, material, type ) {

	THREE.Object3D.call( this );

	this.geometry = geometry;
	this.material = ( material !== undefined ) ? material : new THREE.LineBasicMaterial( { color: Math.random() * 0xffffff } );
	this.type = ( type !== undefined ) ? type : THREE.LineStrip;

	if ( this.geometry ) {

		if ( ! this.geometry.boundingSphere ) {

			this.geometry.computeBoundingSphere();

		}

	}

};
```

现在翻的过程觉得 todo 内容很多, 但底部链接的源码大多都完成的
不知道怎样管理进度的, 总之, 不是非常全面的文档

Scene
------

`Scene` 也是从 `Object3D` 继承的
http://threejs.org/docs/58/#Reference/Scenes/Scene
https://github.com/mrdoob/three.js/blob/master/src/scenes/Scene.js
注意到 `Fog` 和 `Scene` 是放在差不多一起的, 但不清楚怎么用

Material
------

比较找不到规律...
http://threejs.org/docs/58/#Reference/Materials/Material


