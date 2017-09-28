===============
uart_controller
===============
A simple verilog UART controller.

-----
Usage
-----
The main core is contained under ``uart.v`` and a simple test bench is included ``uart_test.v``.

The serilization of an 8-bit word for UART RS-232 transmission begins with the raising of the enable
bit ``tx_en``.  The ``tx_data`` value is then latched into memory, the word is then serilized and output
over the ``tx`` line.

-------
License
-------
This UART controllwer is licensed under a 3-clause BSD style license (see the ``LICENSE.rst`` file).
