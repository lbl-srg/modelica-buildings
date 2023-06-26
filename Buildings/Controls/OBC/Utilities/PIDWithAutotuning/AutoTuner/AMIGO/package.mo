within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner;
package AMIGO "Package with components related to AMIGO tuners"
annotation (Documentation(info="<html>
<p>
This package contains the blocks to implement AMIGO (approximate M-constrained integral gain optimization) tuners. 
Those AMIGO tuners calculates the parameters of PI/PID controllers based on the parameters of reduced order models.
Those reduced order models approximate the control process.
</p>
<h4>References</h4>
<p>
Garpinger, Olof, Tore Hägglund, and Karl Johan Åström (2014)
\"Performance and robustness trade-offs in PID control.\"
Journal of Process Control 24.5 (2014): 568-577.
</p>
<p>
Åström, Karl Johan and Tore Hägglund  (2004)
\"Revisiting the Ziegler–Nichols step response method for PID control.\"
Journal of process control 14.6 (2004): 635-650.
</p>
</html>"));
end AMIGO;
