bin/test: main.cpp dvbt_reed_solomon_enc_impl.cc encode_rs.c init_rs.c
	mkdir -p $(@D)
	$(CXX) -I. $^ -o $@

.PHONY: clean
clean:
	rm -rf bin