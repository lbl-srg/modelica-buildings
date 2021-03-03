within Buildings.Experimental.Templates.BaseClasses;
expandable connector TerminalBus "Terminal control bus"
  extends Modelica.Icons.SignalBus;

  annotation (
  defaultComponentName="terBus",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
          -100},{100,100}}), graphics={Rectangle(
                extent={{-20,2},{22,-2}},
                lineColor={255,204,51},
                lineThickness=0.5)}),
Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector contains \"default\" signals that might be utilized
in a connection (the input/output causalities of the signals
are determined from the connections to this bus).
</p>
</html>"));

end TerminalBus;
