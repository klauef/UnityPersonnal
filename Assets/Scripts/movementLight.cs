using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class movementLight : MonoBehaviour {

    public float movementFactor;
    public float scaleMovement;
    public bool vertical;

    float moduloTime;
    Vector3 positionInitial;

    // Use this for initialization
    void Start () {
        moduloTime = 0.0f;
        positionInitial = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
        moduloTime = (moduloTime + Time.deltaTime * movementFactor) % (2 * Mathf.PI);
        if (vertical)
        {
            transform.position = new Vector3(positionInitial.x, positionInitial.y + Mathf.Cos(moduloTime) * scaleMovement, positionInitial.z);
        }
        else
        {
            transform.position = new Vector3(positionInitial.x + Mathf.Cos(moduloTime) * scaleMovement, positionInitial.y, positionInitial.z - Mathf.Sin(moduloTime) * scaleMovement);
        }
    }
}
