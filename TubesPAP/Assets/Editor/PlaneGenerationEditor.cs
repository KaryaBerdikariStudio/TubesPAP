using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UIElements;

[CustomEditor(typeof(PlaneGeneration))]
public class PlaneGenerationEditor : Editor
{
    public override void OnInspectorGUI()
    {
        PlaneGeneration planeGen = (PlaneGeneration)target;

        DrawDefaultInspector();

        if (GUILayout.Button("Generate Plane"))
        {
            planeGen.GeneratePlane();
        }
    }
}
