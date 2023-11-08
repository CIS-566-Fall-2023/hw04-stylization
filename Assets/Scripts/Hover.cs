using Unity.Mathematics;
using UnityEngine;
using Random = UnityEngine.Random;

public class Hover : MonoBehaviour
{
    [SerializeField] private float distance = 0.3f;
    [SerializeField] private float speed = 0.6f;
    [SerializeField] private float speedRandomization = 0.3f;

    private Vector3 _initialPos;
    private float _offset;
    private float _speed;

    // Start is called before the first frame update
    void Start()
    {
        _initialPos = transform.position;
        _offset = Random.value * math.PI * 2f;
        _speed = speed + (Random.value * 2f - 1f) * speedRandomization;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = _initialPos + new Vector3(0, math.sin(Time.time * _speed + _offset) * distance);
    }
}