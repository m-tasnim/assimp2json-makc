# remember to chmod +x ./build.sh

if  [ ! -d assimp2json ]; then
	git clone git@github.com:acgessler/assimp2json.git
	cd assimp2json
	git reset --hard 3b4469466120d9dfcf21aa72eeb02cb85fdd7b2c
	git submodule init
	git submodule update
	cd ..
	cp bits/revision.h assimp2json/assimp/code/revision.h
	cp bits/gzguts.h assimp2json/assimp/contrib/zlib/gzguts.h
	cp assimp2json/assimp/contrib/zlib/zconf.h.included assimp2json/assimp/contrib/zlib/zconf.h
fi

# removed:
# exporters: we only need loaders
# C4DImporter.cpp: C4D support is currently MSVC only
# OpenGEXImporter: to skip openddlparser dependecy
# IFCLoader, Q3BSPFileImporter: to skip unzip dependency

if [ ! -f assimp.o ]; then

	emcc \
		assimp2json/assimp/contrib/ConvertUTF/ConvertUTF.c \
		assimp2json/assimp/contrib/zlib/adler32.c assimp2json/assimp/contrib/zlib/compress.c assimp2json/assimp/contrib/zlib/crc32.c assimp2json/assimp/contrib/zlib/deflate.c assimp2json/assimp/contrib/zlib/gzclose.c assimp2json/assimp/contrib/zlib/gzlib.c assimp2json/assimp/contrib/zlib/gzread.c assimp2json/assimp/contrib/zlib/gzwrite.c assimp2json/assimp/contrib/zlib/infback.c assimp2json/assimp/contrib/zlib/inffast.c assimp2json/assimp/contrib/zlib/inflate.c assimp2json/assimp/contrib/zlib/inftrees.c assimp2json/assimp/contrib/zlib/trees.c assimp2json/assimp/contrib/zlib/uncompr.c assimp2json/assimp/contrib/zlib/zutil.c \
		\
		assimp2json/assimp2json/cencode.c \
		-O2 -s NO_BROWSER="1" -s NO_FILESYSTEM="1" -s DISABLE_EXCEPTION_CATCHING="1" -s INVOKE_RUN="0" \
		-o temp.o

	emcc \
		assimp2json/assimp/code/3DSConverter.cpp \
		assimp2json/assimp/code/3DSLoader.cpp \
		assimp2json/assimp/code/ACLoader.cpp \
		assimp2json/assimp/code/ASELoader.cpp \
		assimp2json/assimp/code/ASEParser.cpp \
		assimp2json/assimp/code/AssbinLoader.cpp \
		assimp2json/assimp/code/Assimp.cpp \
		assimp2json/assimp/code/AssimpCExport.cpp \
		assimp2json/assimp/code/B3DImporter.cpp \
		assimp2json/assimp/code/BVHLoader.cpp \
		assimp2json/assimp/code/BaseImporter.cpp \
		assimp2json/assimp/code/BaseProcess.cpp \
		assimp2json/assimp/code/Bitmap.cpp \
		assimp2json/assimp/code/BlenderBMesh.cpp assimp2json/assimp/code/BlenderDNA.cpp assimp2json/assimp/code/BlenderLoader.cpp assimp2json/assimp/code/BlenderModifier.cpp assimp2json/assimp/code/BlenderScene.cpp assimp2json/assimp/code/BlenderTessellator.cpp \
		assimp2json/assimp/code/COBLoader.cpp \
		assimp2json/assimp/code/CSMLoader.cpp \
		assimp2json/assimp/code/CalcTangentsProcess.cpp \
		assimp2json/assimp/code/ColladaLoader.cpp \
		assimp2json/assimp/code/ColladaParser.cpp \
		assimp2json/assimp/code/ComputeUVMappingProcess.cpp \
		assimp2json/assimp/code/ConvertToLHProcess.cpp \
		assimp2json/assimp/code/DXFLoader.cpp \
		assimp2json/assimp/code/DeboneProcess.cpp \
		assimp2json/assimp/code/DefaultIOStream.cpp \
		assimp2json/assimp/code/DefaultIOSystem.cpp \
		assimp2json/assimp/code/DefaultLogger.cpp \
		assimp2json/assimp/code/Exporter.cpp \
		assimp2json/assimp/code/FBXAnimation.cpp assimp2json/assimp/code/FBXBinaryTokenizer.cpp assimp2json/assimp/code/FBXConverter.cpp assimp2json/assimp/code/FBXDeformer.cpp assimp2json/assimp/code/FBXDocument.cpp assimp2json/assimp/code/FBXDocumentUtil.cpp assimp2json/assimp/code/FBXImporter.cpp assimp2json/assimp/code/FBXMaterial.cpp assimp2json/assimp/code/FBXMeshGeometry.cpp assimp2json/assimp/code/FBXModel.cpp assimp2json/assimp/code/FBXNodeAttribute.cpp assimp2json/assimp/code/FBXParser.cpp assimp2json/assimp/code/FBXProperties.cpp assimp2json/assimp/code/FBXTokenizer.cpp assimp2json/assimp/code/FBXUtil.cpp \
		assimp2json/assimp/code/FindDegenerates.cpp \
		assimp2json/assimp/code/FindInstancesProcess.cpp \
		assimp2json/assimp/code/FindInvalidDataProcess.cpp \
		assimp2json/assimp/code/FixNormalsStep.cpp \
		assimp2json/assimp/code/GenFaceNormalsProcess.cpp \
		assimp2json/assimp/code/GenVertexNormalsProcess.cpp \
		assimp2json/assimp/code/HMPLoader.cpp \
		assimp2json/assimp/code/IRRLoader.cpp assimp2json/assimp/code/IRRMeshLoader.cpp assimp2json/assimp/code/IRRShared.cpp \
		assimp2json/assimp/code/Importer.cpp \
		assimp2json/assimp/code/ImporterRegistry.cpp \
		assimp2json/assimp/code/ImproveCacheLocality.cpp \
		assimp2json/assimp/code/JoinVerticesProcess.cpp \
		assimp2json/assimp/code/LWOAnimation.cpp assimp2json/assimp/code/LWOBLoader.cpp assimp2json/assimp/code/LWOLoader.cpp assimp2json/assimp/code/LWOMaterial.cpp \
		assimp2json/assimp/code/LWSLoader.cpp \
		assimp2json/assimp/code/LimitBoneWeightsProcess.cpp \
		assimp2json/assimp/code/MD2Loader.cpp \
		assimp2json/assimp/code/MD3Loader.cpp \
		assimp2json/assimp/code/MD5Loader.cpp assimp2json/assimp/code/MD5Parser.cpp \
		assimp2json/assimp/code/MDCLoader.cpp \
		assimp2json/assimp/code/MDLLoader.cpp assimp2json/assimp/code/MDLMaterialLoader.cpp \
		assimp2json/assimp/code/MS3DLoader.cpp \
		assimp2json/assimp/code/MakeVerboseFormat.cpp \
		assimp2json/assimp/code/MaterialSystem.cpp \
		assimp2json/assimp/code/NDOLoader.cpp \
		assimp2json/assimp/code/NFFLoader.cpp \
		assimp2json/assimp/code/OFFLoader.cpp \
		assimp2json/assimp/code/ObjFileImporter.cpp assimp2json/assimp/code/ObjFileMtlImporter.cpp assimp2json/assimp/code/ObjFileParser.cpp \
		assimp2json/assimp/code/OgreBinarySerializer.cpp assimp2json/assimp/code/OgreImporter.cpp assimp2json/assimp/code/OgreMaterial.cpp assimp2json/assimp/code/OgreStructs.cpp assimp2json/assimp/code/OgreXmlSerializer.cpp \
		assimp2json/assimp/code/OptimizeGraph.cpp \
		assimp2json/assimp/code/OptimizeMeshes.cpp \
		assimp2json/assimp/code/PlyLoader.cpp assimp2json/assimp/code/PlyParser.cpp \
		assimp2json/assimp/code/PostStepRegistry.cpp \
		assimp2json/assimp/code/PretransformVertices.cpp \
		assimp2json/assimp/code/ProcessHelper.cpp \
		assimp2json/assimp/code/Q3DLoader.cpp \
		assimp2json/assimp/code/RawLoader.cpp \
		assimp2json/assimp/code/RemoveComments.cpp \
		assimp2json/assimp/code/RemoveRedundantMaterials.cpp \
		assimp2json/assimp/code/RemoveVCProcess.cpp \
		assimp2json/assimp/code/SGSpatialSort.cpp \
		assimp2json/assimp/code/SMDLoader.cpp \
		assimp2json/assimp/code/STEPFileEncoding.cpp assimp2json/assimp/code/STEPFileReader.cpp \
		assimp2json/assimp/code/STLLoader.cpp \
		assimp2json/assimp/code/SceneCombiner.cpp \
		assimp2json/assimp/code/ScenePreprocessor.cpp \
		assimp2json/assimp/code/SkeletonMeshBuilder.cpp \
		assimp2json/assimp/code/SortByPTypeProcess.cpp \
		assimp2json/assimp/code/SpatialSort.cpp \
		assimp2json/assimp/code/SplitByBoneCountProcess.cpp \
		assimp2json/assimp/code/SplitLargeMeshes.cpp \
		assimp2json/assimp/code/StandardShapes.cpp \
		assimp2json/assimp/code/Subdivision.cpp \
		assimp2json/assimp/code/TargetAnimation.cpp \
		assimp2json/assimp/code/TerragenLoader.cpp \
		assimp2json/assimp/code/TextureTransform.cpp \
		assimp2json/assimp/code/TriangulateProcess.cpp \
		assimp2json/assimp/code/UnrealLoader.cpp \
		assimp2json/assimp/code/ValidateDataStructure.cpp \
		assimp2json/assimp/code/Version.cpp \
		assimp2json/assimp/code/VertexTriangleAdjacency.cpp \
		assimp2json/assimp/code/XFileImporter.cpp assimp2json/assimp/code/XFileParser.cpp \
		assimp2json/assimp/code/XGLLoader.cpp \
		\
		assimp2json/assimp/contrib/clipper/clipper.cpp \
		assimp2json/assimp/contrib/irrXML/irrXML.cpp \
		\
		assimp2json/assimp2json/json_exporter.cpp \
		assimp2json/assimp2json/mesh_splitter.cpp \
		\
		temp.o \
		\
		-I assimp2json/assimp/code/BoostWorkaround \
		-I assimp2json/assimp2json/ -I assimp2json/assimp/include/ -I assimp2json/assimp/code/ \
		-DASSIMP_BUILD_NO_COLLADA_EXPORTER -DASSIMP_BUILD_NO_XFILE_EXPORTER -DASSIMP_BUILD_NO_OBJ_EXPORTER -DASSIMP_BUILD_NO_STL_EXPORTER -DASSIMP_BUILD_NO_PLY_EXPORTER -DASSIMP_BUILD_NO_3DS_EXPORTER -DASSIMP_BUILD_NO_ASSBIN_EXPORTER -DASSIMP_BUILD_NO_ASSXML_EXPORTER \
		-Wno-tautological-compare \
		-DASSIMP_BUILD_NO_C4D_IMPORTER -DASSIMP_BUILD_NO_IFC_IMPORTER -DASSIMP_BUILD_NO_OPENGEX_IMPORTER -DASSIMP_BUILD_NO_Q3BSP_IMPORTER \
		-O2 -s NO_BROWSER="1" -s NO_FILESYSTEM="1" -s DISABLE_EXCEPTION_CATCHING="1" -s INVOKE_RUN="0" \
		-o assimp.o

	unlink temp.o
fi

emcc \
	assimp.cpp \
	assimp.o \
	-I assimp2json/assimp2json/ -I assimp2json/assimp/include/ -I assimp2json/assimp/code/ \
	-s TOTAL_MEMORY=80088008 \
	-O2 -s NO_BROWSER="1" -s NO_FILESYSTEM="1" -s DISABLE_EXCEPTION_CATCHING="1" -s INVOKE_RUN="0" \
	--bind --pre-js bits/a.js --post-js bits/b.js -o assimp.js \
	--memory-init-file 0 \
