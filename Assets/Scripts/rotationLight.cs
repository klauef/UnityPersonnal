using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotationLight : MonoBehaviour {

    public float rotationFactor;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        transform.Rotate(0.0f, rotationFactor, 0.0f);
    }
}
