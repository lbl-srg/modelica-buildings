within Buildings.Templates.Components;
package Interfaces "Interface classes"
  extends Modelica.Icons.InterfacesPackage;

  expandable connector Bus "Control bus"
    extends Modelica.Icons.SignalBus;

    annotation (
      defaultComponentName="bus");
  end Bus;
end Interfaces;
