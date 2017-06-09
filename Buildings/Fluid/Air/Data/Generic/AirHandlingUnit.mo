within Buildings.Fluid.Air.Data.Generic;
record AirHandlingUnit "Performance data for air handling unit"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.Air.Data.Generic.BaseClasses.NominalValue nomVal
  "Data record for AHU nominal values";
  parameter Buildings.Fluid.Air.Data.Generic.BaseClasses.PerformanceCurve perCur
  "Data record for fan performance data";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This record declares the performance data for the air handler model. The performance data are structured as follows: </p>
<pre>    nomVal  - Nominal performance values for each component. 
              Data of the nomVal record are
       T_a1_nominal    - Nominal water inlet temperature
       T_b1_nominal    - Nominal water outlet temperature
       T_a2_nominal    - Nominal air inlet temperature
       T_b2_nominal    - Nominal air outlet temperature
       Q_flow_nominal    - Nominal heat transfer
       m1_flow_nominal    - Nominal water mass flowrate
       m2_flow_nominal    - Nominal air mass flowrate
       dpCoil1__nominal    - Nominal pressure difference on water side of the coil     
       dpCoil2__nominal    - Nominal pressure difference on air side of the coil 
       UA_nominal      - Thermal conductance at nominal flow for sensible heat, used to compute time constant
       r_nominal       - Ratio between air-side and water-side convective heat transfer coefficient
       tau1            - Time constant at nominal flow of water
       tau2            - Time constant at nominal flow of air
       tau_m           - Time constant of metal at nominal UA value
       nEle            - Number of pipe segments used for discretization in the cooling coil
       mWat_flow_nominal    - Nominal water mass flowrate for humidifier
       dpHumidifier_nominal - Nominal pressure difference in the humidifier
       dpHeater_nominal     - Nominal pressure difference in the heater
       QHeater_nominal      - Nominal heat flow in the electric heater
       effHeater_nominal    - Nominal efficiency of the electric heater
       dpValve_nominal      - Nominal pressure difference in the water-side valve of cooling coil

    perCur  - Records with performance curve for the fan in the air hanlder. </pre>
<p>The data used to develop the performance curve of the fan should follow the record in <a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">Buildings.Fluid.Movers.Data.Generic</a>. </p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHandlingUnit;
