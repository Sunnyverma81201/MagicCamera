//
//  Publisher+Extension.swift
//  MarkAR
//
//  Created by Apoorv Verma on 10/09/23.
//

import Combine

extension Publisher {
    func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
