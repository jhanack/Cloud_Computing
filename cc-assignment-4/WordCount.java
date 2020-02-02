package org.example;

/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.util.Collector;
import org.apache.flink.api.common.operators.Order;

public class WordCount {

	public static void main(String[] args) throws Exception {

		// set up the execution environment
		final ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();

		DataSet<String> localLines = env.readTextFile("/Users/maxksoll/Uni/Aktuell/Cloud Computing/WordCount/tolstoy-war-and-peace.txt");

		DataSet<Tuple2<String, Integer>> counts =
				// split up the lines in pairs (2-tuples) containing: (word,1)
				localLines.flatMap(new LineSplitter())
				// group by the tuple field "0" and sum up tuple field "1"
				// with an additional sort on the value "1" in decending order
				.groupBy(0)
				.sum(1)
				.sortPartition(1, Order.DESCENDING);

		// execude the defined actions from counts definition and print the result
		counts.print();

	}

	// the LineSplitter class defines how the lines should be treated and builds structure
	// for map and reduce concept
	public static final class LineSplitter implements FlatMapFunction<String, Tuple2<String, Integer>> {

		@Override
		public void flatMap(String value, Collector<Tuple2<String, Integer>> out) {
			// normalize and split the line
			// all words are already set in to lower case to ignore case
			String[] tokens = value.toLowerCase().split("\\W+");

			// emit the pairs
			for (String token : tokens) {
				// regular expression filters all additional values which are not allowed
				if (token.length() > 0 && !token.matches(".*[0-9_].*")) {
					// this tuple is now handed to the group by, sum and order
					out.collect(new Tuple2<String, Integer>(token, 1));
				}
			}
		}
	}
}
