within Buildings.Obsolete.Fluid.SolarCollectors.BaseClasses;
block PartialParameters "Partial model for parameters"

  parameter Modelica.Units.SI.Area A_c "Area of the collector";
  parameter Integer nSeg(min=3)=3 "Number of segments";
  parameter Real y_intercept "Y intercept (Maximum efficiency)";

  annotation(Documentation(info="<html>
    <p>
      Partial parameters used in all solar collector models
    </p>
  </html>",
  revisions="<html>
    <ul>
      <li>
        Apr 17, 2013, by Peter Grant:<br/>
        First implementation
      </li>
    </ul>
  </html>"));
end PartialParameters;
