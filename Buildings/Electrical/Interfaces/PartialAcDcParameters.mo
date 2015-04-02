within Buildings.Electrical.Interfaces;
record PartialAcDcParameters
  "Partial model that contains basic parameters for a DC/AC conversion system"
  parameter Real pf(min=0, max=1) = 0.9 "Power factor"
    annotation (Dialog(group="AC-Conversion"));
  parameter Real eta_DCAC(min=0, max=1) = 0.9 "Efficiency of DC/AC conversion"
    annotation (Dialog(group="AC-Conversion"));
  annotation (Documentation(info="<html>
<p>
This model contains the minimum set of parameters necessary to describe
an AC/DC converter.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialAcDcParameters;
