using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cubeRotation : MonoBehaviour {

    public float rotationFactor;

    void Start () {
		
	}
	
	void Update () {
        transform.Rotate(0.2f * rotationFactor, 0.1f * rotationFactor, 0.3f * rotationFactor);
        GetComponent<MeshFilter>().mesh.RecalculateBounds();
	}
}
