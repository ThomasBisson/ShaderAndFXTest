using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScript : MonoBehaviour
{
    int cpt = 0;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (cpt < 3)
        {
            Deplace1(true);
            cpt = cpt + 1;
        }
        else
        {
            Deplace1(false);
            cpt--;
        }
        Debug.Log(cpt);
    }


    void Deplace1(bool a)
    {
            if(a)
                transform.position = transform.position + new Vector3(1, 0, 0);
            else
                transform.position = transform.position - new Vector3(1, 0, 0);
        }
}
