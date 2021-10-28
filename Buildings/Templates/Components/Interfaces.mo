within Buildings.Templates.Components;
package Interfaces "Classes defining the component interfaces"
  extends Modelica.Icons.InterfacesPackage;

  expandable connector Bus "Main control bus"
    extends Modelica.Icons.SignalBus;

    annotation (
      defaultComponentName="bus");
  end Bus;
end Interfaces;
