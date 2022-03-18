within Buildings.Templates.Components;
package Interfaces "Interface classes"
  extends Modelica.Icons.InterfacesPackage;

  expandable connector Bus "Control bus"
    extends Modelica.Icons.SignalBus;

    annotation (
      defaultComponentName="bus", Documentation(info="<html>
<p>
This expandable connector provides a standard interface for 
all control signals of the component models. 
</p>
</html>"));
  end Bus;
  annotation (Documentation(info="<html>
<p>
This package contains interface classes.
</p>
</html>"));
end Interfaces;
