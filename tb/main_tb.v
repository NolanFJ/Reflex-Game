

task press_button(input integer wait_time, duration);
    #wait_time;
    button_press = 1;
    #duration;
    button_press = 0;
endtask

initial begin
    button_press = 0;
    press_button(1000, 50);   // Press at 1000, hold for 50
    press_button(2000, 50);   // Another press 2000 later
end