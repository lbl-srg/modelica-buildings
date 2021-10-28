within Buildings.Templates.Validation;
model NestedUndeclaredExpandable
  extends Modelica.Icons.Example;

  model AHU
    Controller con;
    Fan fan;
    Buildings.Templates.AirHandlersFans.Interfaces.Bus bus;
  equation
    connect(con.bus, bus);
    connect(bus.fan, fan.bus);
  end AHU;

  model Fan
    Buildings.Controls.OBC.CDL.Interfaces.RealInput y;
    Buildings.Templates.Components.Interfaces.Bus bus;
  equation
    connect(bus.y, y);
  end Fan;

  block Controller
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan
    "Fan control signal";
    Buildings.Templates.AirHandlersFans.Interfaces.Bus bus;
  equation
    yFan = 1;
    connect(yFan, bus.fan.y);
  end Controller;

  AHU ahu;

end NestedUndeclaredExpandable;
