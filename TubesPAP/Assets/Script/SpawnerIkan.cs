using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;

public class SpawnerIkan : MonoBehaviour
{
    public Transform t;
    public GameObject ikan;
    public int jumlahIkan;

    public List<GameObject> listIkan = new List<GameObject>();

    private void Update()
    {
        IkanMuncul();   
    }

    IEnumerator IkanMuncul()
    {
        yield return new WaitForSeconds(0.5f);

        Debug.Log("Ikan");

        ikan = Resources.Load("Assets/3DModel/Ikan/Fish3.fbx", typeof(GameObject)) as GameObject;
        jumlahIkan = listIkan.Count;

        Spawn();
    }

    public void Spawn()
    {
        if (jumlahIkan < 10)
        {
            listIkan.Add(Instantiate(ikan, new Vector3(t.position.x, t.position.y + -5f, t.position.z), t.rotation));
        }
    }



}
