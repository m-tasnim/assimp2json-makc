#include <stdio.h> /* printf() */

#include <assimp/Importer.hpp>
#include <assimp/Exporter.hpp>

#include <assimp/postprocess.h>
#include <assimp/scene.h>

// json_exporter.cpp
extern Assimp::Exporter::ExportFormatEntry Assimp2Json_desc;


#include <emscripten/bind.h>
using namespace emscripten;


void parse (const std::string& buffer, const std::string& hint,

	// https://groups.google.com/d/msg/emscripten-discuss/VydYULScxrw/BFYSkOoZZqsJ
	emscripten::val done) {

	Assimp::Importer imp;

	// instruct aiProcess_FindDegenerates to drop degenerates 
	imp.SetPropertyBool(AI_CONFIG_PP_FD_REMOVE, true);
	// instruct aiProcess_SortByPrimitiveType to drop line and point meshes
	imp.SetPropertyInteger(AI_CONFIG_PP_SBP_REMOVE, aiPrimitiveType_POINT | aiPrimitiveType_LINE);

	// instruct aiProcess_GenSmoothNormals to not smooth normals with an angle of more than 70deg
	imp.SetPropertyFloat(AI_CONFIG_PP_GSN_MAX_SMOOTHING_ANGLE, 70.0f);
	// instruct aiProcess_CalcTangents to not smooth normals with an angle of more than 70deg
	imp.SetPropertyFloat(AI_CONFIG_PP_CT_MAX_SMOOTHING_ANGLE, 70.0f);

	const aiScene* const sc = imp.ReadFileFromMemory (
		(void *)buffer.c_str (),
		buffer.length (),
		aiProcessPreset_TargetRealtime_MaxQuality,
		hint.c_str ()
	);

	if (!sc) {
		printf ("Well, shit. ReadFileFromMemory failed to return anything\n");
		return;
	}

	Assimp::Exporter exp;
	exp.RegisterExporter(Assimp2Json_desc);

	const aiExportDataBlob* const blob = exp.ExportToBlob(sc,"assimp.json");
	if (!blob) {
		printf ("Export failed. %s\n", exp.GetErrorString());
		return;
	}

	const std::string s(static_cast<char*>( blob->data), blob->size);
	done (s);
}


EMSCRIPTEN_BINDINGS(my_module) {
	function("parse", &parse);
}