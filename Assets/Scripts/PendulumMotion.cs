using UnityEngine;

public class PendulumMotion : MonoBehaviour
{
    public float angle = 45.0f;      // Max angle from the vertical (in degrees)
    public float speed = 1.5f;       // Speed factor
    private float _startTime;

    private Quaternion _start, _end;

    void Start()
    {
        // Set up the pendulum's initial positions
        _start = Quaternion.Euler(0, 0, angle);
        _end = Quaternion.Euler(0, 0, -angle);

        // Record the start time
        _startTime = Time.time;
    }

    void Update()
    {
        // Calculate the pendulum's current position using a sine wave over time
        float timePassed = Time.time - _startTime;
        float swing = Mathf.Sin(timePassed * speed) * angle;
        transform.rotation = Quaternion.Euler(swing, 0, 0);
    }
}
