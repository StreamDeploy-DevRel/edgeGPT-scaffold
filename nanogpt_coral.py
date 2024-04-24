import numpy as np
import tensorflow as tf
from pycoral.adapters import common
from pycoral.adapters import classify
from pycoral.utils.edgetpu import make_interpreter

def main():
    interpreter = make_interpreter('model_quant_edgetpu.tflite')
    interpreter.allocate_tensors()

    input_shape = interpreter.get_input_details()[0]['shape']
    input_data = np.array(np.random.random_sample(input_shape), dtype=np.float32)
    interpreter.set_tensor(interpreter.get_input_details()[0]['index'], input_data)

    interpreter.invoke()

    output_data = interpreter.get_tensor(interpreter.get_output_details()[0]['index'])
    print(output_data)

if __name__ == "__main__":
    main()
