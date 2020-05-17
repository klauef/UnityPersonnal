using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sphereBehavior : MonoBehaviour {

    public float mass;

    Vector3 gravity;
    // velocities for each spheres in the sphereList
    Vector3[] velocities;
    
    // function which simulate the collision between cube and spheres
    void collisionCube(int childNumber, Transform trans, float radius)
    {
        GameObject cube = GameObject.Find("cube");
        MeshFilter mfCube = cube.GetComponent<MeshFilter>();
        Vector3[] cubeVertices = mfCube.mesh.vertices;
        Vector3 min = Vector3.positiveInfinity;
        Vector3 max = Vector3.negativeInfinity;
        Vector3 v;
        //recompute of the bounds of the cube
        for(int i = 0; i < cubeVertices.Length; i++)
        {
            v = cubeVertices[i];
            min = new Vector3(Mathf.Min(min.x, v.x), Mathf.Min(min.y, v.y), Mathf.Min(min.z, v.z));
            max = new Vector3(Mathf.Max(max.x, v.x), Mathf.Max(max.y, v.y), Mathf.Max(max.z, v.z));
        }
        
        Transform transCube = cube.transform;
        Vector3 pos = transCube.InverseTransformPoint(trans.position);
        Vector3 vel = transCube.InverseTransformVector(velocities[childNumber]);
        Vector3 scale = transCube.InverseTransformVector(trans.lossyScale);
        radius = (scale.x + scale.y + scale.z) / 3.0f * this.GetComponentsInChildren<SphereCollider>()[childNumber].radius;

        //we test if the sphere collision with the cube
        if (pos.x - radius < min.x)
        {
            pos = new Vector3(min.x + radius, pos.y, pos.z);
            vel.x = 0.5f * -vel.x;
        }

        if (pos.x + radius > max.x)
        {
            pos = new Vector3(max.x - radius, pos.y, pos.z);
            vel.x = 0.5f * -vel.x;
        }

        if (pos.y - radius < min.y)
        {
            pos = new Vector3(pos.x, min.y + radius, pos.z);
            vel.y = 0.5f * -vel.y;
        }

        if (pos.y + radius > max.y)
        {
            pos = new Vector3(pos.x, max.y - radius, pos.z);
            vel.y = 0.5f * -vel.y;
        }

        if (pos.z - radius < min.z)
        {
            pos = new Vector3(pos.x, pos.y, min.z + radius);
            vel.z = 0.5f * -vel.z;
        }

        if (pos.z + radius > max.z)
        {
            pos = new Vector3(pos.x, pos.y, max.z - radius);
            vel.z = 0.5f * -vel.z;
        }

        trans.position = transCube.TransformPoint(pos);
        velocities[childNumber] = transCube.TransformVector(vel);
    }

    // function which simulate the collision between spheres
    void collisionBalls(int childNumber, Transform transAct, float radiusAct)
    {

        Transform transOther;
        float radiusOther;
        float dist;

        //for each other spheres
        for (int i = 0; i < transform.childCount; i++)
        {
            //if we don't compute the collision with itself
            if (i != childNumber)
            {
                transOther = transform.GetChild(i);
                radiusOther = (transOther.lossyScale.x + transOther.lossyScale.y + transOther.lossyScale.z) / 3.0f * this.GetComponentsInChildren<SphereCollider>()[i].radius;
                //if we have a collision, so compute the collision effect
                if (Vector3.Distance(transAct.position, transOther.position)  < radiusAct + radiusOther)
                {
                    dist = (radiusAct + radiusOther) - Vector3.Distance(transAct.position, transOther.position);
                    velocities[i] += (transOther.position - transAct.position) * dist * 0.5f;
                    velocities[childNumber] += (transAct.position - transOther.position) * dist * 0.5f;
                }
            }
        }
    }

    // function which call collisionBalls and collisionCube
    void collisions(int childNumber)
    {
        Transform trans = transform.GetChild(childNumber);
        float radius = (trans.lossyScale.x + trans.lossyScale.y + trans.lossyScale.z) / 3.0f * this.GetComponentsInChildren<SphereCollider>()[childNumber].radius;

        collisionCube(childNumber, trans, radius);
        collisionBalls(childNumber, trans, radius);

    }

	void Start () {
        gravity = new Vector3(0.0f, -9.81f, 0.0f);
        velocities = new Vector3[transform.childCount];

        for (int i = 0; i < velocities.Length; i++)
        {
            velocities[i] = new Vector3(0.0f, 0.0f, 0.0f);
        }
	}
	
	void Update ()
    {
        Transform trans;

        //for each sphere we want to compute collisions, new velocities and new positions
        for (int i = 0; i < transform.childCount; i++)
        {
            trans = transform.GetChild(i);

            collisions(i);

            velocities[i] += (gravity * mass) * Time.deltaTime;
            trans.position += velocities[i] * Time.deltaTime;
        }
	}
}
