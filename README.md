# Millenium Digital Clock

**Project Overview**
- **Purpose**: Hiển thị giờ, phút, giây và ngày/tháng/năm trên 7-segment; có chế độ thời gian/thiết lập thủ công với nút lên/xuống và lựa chọn mục cần set.
- Phục vụ cho mục đích luyện tập Verilog HDL.

**Key Source Files**
- **Top-level**: [top_control.v](top_control.v) — kết nối giao diện người dùng, debouncer, bộ đếm và điều khiển hiển thị.
- **Counter & timing**: [counter_control.v](counter_control.v), [gen_clock.v](gen_clock.v), [second_counter.v](second_counter.v), [minute_counter.v](minute_counter.v), [hour_counter.v](hour_counter.v), [day_counter.v](day_counter.v), [month_counter.v](month_counter.v), [year_counter.v](year_counter.v).
- **Display**: [display_control.v](display_control.v), [display_blink.v](display_blink.v), [display_decoder.v](display_decoder.v), [seg_decoder.v](seg_decoder.v), [bin_to_bcd.v](bin_to_bcd.v).
- **Utilities**: [debounce_button.v](debounce_button.v).

**High-level Architecture & Dataflow**
- **Clock generation**: `gen_clock` sinh tín hiệu xung cho giây (`signal_sec`) và chuỗi tín hiệu đẩy sang phút/giờ/ngày.
- **Counters**: Các block `*_counter` (second/minute/hour/day/month/year) nhận tín hiệu chuỗi (`signal_in`) và xuất `signal_out` cho cấp tiếp theo khi tràn.
- **Manual set**: `counter_control` cho phép thiết lập thủ công bằng cách bật `manual_set` cùng với `select_item` (3-bit) để chọn second/minute/hour/day/month/year; nút `up`/`down` (được debounce) điều chỉnh giá trị tương ứng.
- **Hiển thị**: `display_control` thu giá trị thời gian/ngày và điều khiển các anode/cathode 7-seg (HEX0..HEX7) thông qua `seg_decoder` và logic nhấp nháy (`display_blink`).

**I/O Signals & Interfaces**
- **Inputs (top_control.v)**: `clk`, `btn_rst_n`, `btn_up`, `btn_down`, `sw_mode` (chế độ time/set), `sw_start_manual` (bắt đầu set), `sw_select_item[2:0]` (chọn mục set).
- **Outputs (top_control.v)**: `HEX0`..`HEX7` — 7-segment displays.
- **Widths**: `second/minute/hour/day` are 6-bit, `month` is 4-bit, `year` is 14-bit (the project uses 14 bits for year storage).

**Solution for Leap Year & max_day logic**
- `counter_control.v` tính `leap_year` bằng cách kiểm tra `year[1:0] == 2'b00` (chia hết cho 4) rồi dùng một `case` để loại trừ một số năm thế kỷ cụ thể (ví dụ 2100, 2200, ...). Sau đó `max_day` cho tháng 2 là 29 nếu leap, ngược lại 28.
- **Ghi chú**: Cách triển khai này hoạt động cho phần lớn năm, nhưng xử lý năm thế kỷ là cứng mã hóa một số giá trị (thay vì dùng quy tắc chia hết cho 400). Nếu cần chính xác lâu dài, nên áp dụng luật chuẩn: năm chia hết cho 400 là leap; chia hết cho 100 nhưng không chia hết cho 400 thì không leap.

**Build / Run / Simulate**
- 
- **Synth & FPGA**: Sử dụng Intel Quartus để nạp và triển khai trên FPGA.
- **Simulation**: Sử dụng QuestaSim để chạy mô phỏng các bộ đếm thời gian, quan sát sự phối hợp giữa các bộ đếm.

Điều chỉnh lệnh tuỳ theo testbench và tập tin mô phỏng bạn có.

**How to manually set time/date (user-facing)**
- **Chế độ**: chuyển `sw_mode` để chọn giữa hiển thị thời gian hoặc chế độ thiết lập.
- **Bắt đầu thiết lập**: kéo `sw_start_manual` (manual_set) để bật chế độ set.
- **Chọn mục**: `sw_select_item` (3-bit): mỗi mã chọn second/minute/hour/day/month/year theo logic trong `counter_control.v`.
- **Điều chỉnh**: dùng `btn_up` / `btn_down` (đã debounce) để tăng/giảm mục đang chọn.

**Potential Enhancements / Notes**
- Tối ưu hóa leap-year: Một số cách khác để xử lý **leap-year**
  Sử dụng bin_to_bcd để kiểm tra
  Sử dụng phép chia để kiểm tra (không khuyến khích vì phép chia tốn tài nguyên phần cứng)
  
- Cần bổ sung thêm các testcase để kiểm thử các boundary (31/30 ngày, leap year, end-of-year rollover).
